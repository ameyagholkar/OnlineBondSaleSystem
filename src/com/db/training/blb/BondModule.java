package com.db.training.blb;

import java.sql.ResultSet;
import java.sql.SQLException;
import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;
import com.db.training.blb.objects.ConfirmationData;

public class BondModule {

	public ResultSet getListOfBonds(SearchCriteria criteria)
			throws SQLException {
		QueryEngine queryEngine = null;
		try {
			queryEngine = new QueryEngine(new ConnectionEngine());
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		ResultSet rs = queryEngine
				.query("select * from blb.bonds "
						+ "where "
						+ "bond_name like ? and issuer_name like ? and "
						+ "(rating_snp between ? and ? "
						+ "or rating_moody between ? and ?) "
						+ "and coupon_rate between ? and ? "
						+ "and current_yield between ? and ? "
						+ "and maturity_yield between ? and ? "
						+ "and timestamp(maturity_date) between timestamp(?) and timestamp(?) "
						+ "and par_value between ? and ? "
						+ "and price between ? and ? "
						+ "and group_id=0 and quantity_owned > 0",
						criteria.name,
						criteria.issuer,
						new Integer(SearchCriteria
								.getNumericRating(criteria.ratingLow))
								.toString(),
						new Integer(SearchCriteria
								.getNumericRating(criteria.ratingHigh))
								.toString(),
						new Integer(SearchCriteria
								.getNumericRating(criteria.ratingLow))
								.toString(),
						new Integer(SearchCriteria
								.getNumericRating(criteria.ratingHigh))
								.toString(), criteria.couponRateLow,
						criteria.couponRateHigh, criteria.currentYieldLow,
						criteria.currentYieldHigh, criteria.yield2MaturityLow,
						criteria.yield2MaturityHigh, criteria.maturityDateLow,
						criteria.maturityDateHigh, criteria.parValueLow,
						criteria.parValueHigh, criteria.priceLow,
						criteria.priceHigh);
		if (!rs.next()) {
			return null;
		}
		return rs;
	}

	public ConfirmationData processBondOrder(String cusip, String numOfBonds,
			String customerId, String totalPrice, String sessionId) {
		QueryEngine queryEngine = getQueryEngine();

		ResultSet userSet;
		try {
			// Get the Customers Group ID
			userSet = getGroupIdFromCustomerId(customerId, queryEngine);
			int userGroupId = userSet.getInt("group_id");
			double userBalance = userSet.getDouble("balance");
			// Select All bond data from Bonds table which corresponds to the
			// required bond.
			ResultSet bondReq = queryEngine.query(
					"select * from bonds where cusip=? and group_id=0", cusip);
			bondReq.first();
			// Check to ensure that the customer has the required balance
			if (userBalance < Double.parseDouble(totalPrice)) {
				return new ConfirmationData(3);
			} else {
				userBalance = userBalance - Double.parseDouble(totalPrice);
			}
			// If the Available quantity is greater than equal to the requested
			// number - let the order go through
			int availableQuantity = bondReq.getInt(11);
			if (availableQuantity >= Integer.parseInt(numOfBonds)) {
				availableQuantity = availableQuantity
						- Integer.parseInt(numOfBonds); // Get the
				// updated
				// Bonds.
			} else {
				return new ConfirmationData(2);
			}
			// Update Bonds table to reflect that the bonds are now processing -
			// reduce the quantity
			queryEngine
					.getConnectionEngine()
					.update("update bonds set quantity_owned=? where cusip=? and group_id=0",
							String.valueOf(availableQuantity), cusip);
			// update Customer's Balance with the new balance.
			queryEngine.getConnectionEngine().update(
					"update customers c set c.balance=? where c.id=?",
					String.valueOf(userBalance), customerId);
			// Check if the customer has the bond with the same ID
			ResultSet countOfUserBonds = queryEngine
					.query("select count(*), quantity_owned from bonds where cusip=? and group_id=?",
							cusip, String.valueOf(userGroupId));
			countOfUserBonds.first();
			// If no, insert new record for the bond purchase with customer's
			// group ID. IF yes, Update the existing record to reflect the new
			// quantity.
			if (countOfUserBonds.getInt(1) == 0) {
				queryEngine
						.getConnectionEngine()
						.update("insert into bonds values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
								bondReq.getString("cusip"),
								String.valueOf(bondReq.getInt("rating_snp")),
								String.valueOf(bondReq.getInt("rating_moody")),
								String.valueOf(bondReq.getDouble("coupon_rate")),
								String.valueOf(bondReq
										.getDouble("current_yield")),
								String.valueOf(bondReq
										.getDouble("maturity_yield")),
								String.valueOf(bondReq.getDate("maturity_date")),
								String.valueOf(bondReq.getDouble("par_value")),
								String.valueOf(bondReq.getDouble("price")),
								String.valueOf(userGroupId), numOfBonds,
								bondReq.getString("bond_name"),
								bondReq.getString("issuer_name"),
								String.valueOf(bondReq.getInt("bond_type")));
			} else {
				int userOwnedQuantity = countOfUserBonds.getInt(2);
				userOwnedQuantity = userOwnedQuantity
						+ Integer.parseInt(numOfBonds);
				queryEngine
						.getConnectionEngine()
						.update("update bonds set quantity_owned=? where cusip=? and group_id=?",
								String.valueOf(userOwnedQuantity), cusip,
								String.valueOf(userGroupId));

			}
			// Get Trader ID
			int traderId = queryEngine.getTraderIdFromSessionId(sessionId);
			// Get the current Date Time
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			String transactionUpdateQuery = "INSERT INTO transactions (buyer_id, seller_id, trader_id, transaction_date, bond_cusip, quantity, transaction_status) VALUES (?,?,?,?,?,?,?)";
			queryEngine.getConnectionEngine().update(transactionUpdateQuery,
					String.valueOf(userGroupId),
					String.valueOf(bondReq.getInt("group_id")),
					String.valueOf(traderId), currentTime, cusip, numOfBonds,
					"0");
			return new ConfirmationData(1, currentTime);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return new ConfirmationData(0);
	}

	public ResultSet getTransactionDataFromDate(String date, String customerId, int sell) {
		QueryEngine queryEngine = getQueryEngine();
		String query = "";

		try {
			if (sell == 0) {
				query = "select tr.bond_cusip as cusip, tr.quantity as quantity, tr.transaction_date as date, tr.transaction_status as status, t.username as tusername, c.full_name as cname, c.balance as balance, b.price as price, b.rating_snp as rating_snp, b.rating_moody as rating_moody, tr.id as transaction_id from transactions tr join traders t on tr.trader_id = t.id join bonds b on b.cusip = tr.bond_cusip  join groups g on b.group_id = g.id and tr.buyer_id = g.id join customers c on c.id = g.participant_id where tr.transaction_date=? and c.id=?";
			} else {
				query = "select tr.bond_cusip as cusip, tr.quantity as quantity, tr.transaction_date as date, tr.transaction_status as status, t.username as tusername, c.full_name as cname, c.balance as balance, b.price as price, b.rating_snp as rating_snp, b.rating_moody as rating_moody, tr.id as transaction_id from transactions tr join traders t on tr.trader_id = t.id join bonds b on b.cusip = tr.bond_cusip  join groups g on b.group_id = g.id and tr.buyer_id = 0 join customers c on c.id = g.participant_id where tr.transaction_date=? and c.id=?";
			}
			ResultSet rs = queryEngine.query(query, date, customerId);
			return rs;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	public boolean cancelTransaction(String customerId, String transaction_id) {
		QueryEngine queryEngine = getQueryEngine();
		// Get the Customers Group ID
		ResultSet userSet;
		try {
			userSet = getGroupIdFromCustomerId(customerId, queryEngine);
			// cancel Transaction
			ResultSet trnscData = executeCancelTransactionCommonQueries(
					transaction_id, queryEngine);
			int quantity = trnscData.getInt("quantity");
			ResultSet bondData = getBondPriceFromBondTable(queryEngine,
					trnscData);
			double priceToBeAdded = quantity * bondData.getDouble("price");
			// update balance and quantity
			String updateBalanceQuery = "update customers set balance=balance+? where id=?";
			String updateQuantityQuery = "update bonds set quantity_owned=quantity_owned+? where cusip=? and group_id=0";
			String updateCustomerQuantityQuery = "update bonds set quantity_owned=quantity_owned-? where cusip=? and group_id=?";
			queryEngine.getConnectionEngine().update(updateBalanceQuery,
					String.valueOf(priceToBeAdded), customerId);
			queryEngine.getConnectionEngine()
					.update(updateQuantityQuery, String.valueOf(quantity),
							trnscData.getString("bond_cusip"));
			queryEngine.getConnectionEngine().update(
					updateCustomerQuantityQuery, String.valueOf(quantity),
					trnscData.getString("bond_cusip"),
					String.valueOf(userSet.getInt("group_id")));

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean cancelTransaction2(String customerId, String transaction_id) {
		QueryEngine queryEngine = getQueryEngine();
		// Get the Customers Group ID
		ResultSet userSet;
		try {
			userSet = getGroupIdFromCustomerId(customerId, queryEngine);
			// cancel Transaction
			ResultSet trnscData = executeCancelTransactionCommonQueries(
					transaction_id, queryEngine);
			int quantity = trnscData.getInt("quantity");
			ResultSet bondData = getBondPriceFromBondTable(queryEngine,
					trnscData);
			double priceToBeSubtracted = quantity * bondData.getDouble("price");
			// update balance and quantity
			String updateBalanceQuery = "update customers set balance=balance-? where id=?";
			String updateQuantityQuery = "update bonds set quantity_owned=quantity_owned-? where cusip=? and group_id=0";
			String updateCustomerQuantityQuery = "update bonds set quantity_owned=quantity_owned+? where cusip=? and group_id=?";
			queryEngine.getConnectionEngine().update(updateBalanceQuery,
					String.valueOf(priceToBeSubtracted), customerId);
			queryEngine.getConnectionEngine()
					.update(updateQuantityQuery, String.valueOf(quantity),
							trnscData.getString("bond_cusip"));
			queryEngine.getConnectionEngine().update(
					updateCustomerQuantityQuery, String.valueOf(quantity),
					trnscData.getString("bond_cusip"),
					String.valueOf(userSet.getInt("group_id")));

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	private QueryEngine getQueryEngine() {
		QueryEngine queryEngine = null;

		try {
			queryEngine = new QueryEngine(new ConnectionEngine());
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return queryEngine;
	}

	private ResultSet getBondPriceFromBondTable(QueryEngine queryEngine,
			ResultSet trnscData) throws SQLException {
		ResultSet bondData = queryEngine
				.query("select distinct(b.price) as price from bonds b where cusip = ? and b.group_id=0",
						trnscData.getString("bond_cusip"));
		bondData.first();
		return bondData;
	}

	private ResultSet executeCancelTransactionCommonQueries(
			String transaction_id, QueryEngine queryEngine) throws SQLException {
		queryEngine
				.getConnectionEngine()
				.update("insert into transactions (buyer_id,seller_id,trader_id,transaction_date,bond_cusip,quantity,transaction_status) SELECT buyer_id,seller_id,trader_id,now(),bond_cusip,quantity,3 FROM transactions where id = ?",
						transaction_id);
		queryEngine.getConnectionEngine().update(
				"update transactions set processed=1 where id=?",
				transaction_id);
		// update quantity
		ResultSet trnscData = queryEngine
				.query("select tr.bond_cusip as bond_cusip, tr.quantity as quantity from transactions tr where id = ?",
						transaction_id);
		trnscData.first();
		return trnscData;
	}

	private ResultSet getGroupIdFromCustomerId(String customerId,
			QueryEngine queryEngine) throws SQLException {
		ResultSet userSet;
		userSet = queryEngine
				.query("select g.id as group_id, c.balance as balance from customers c, groups g where g.group_type=1 and c.id=? and c.id = g.participant_id;",
						customerId);
		userSet.first();
		return userSet;
	}

	public ConfirmationData sellBond(String cusip, String customerId,
			String quantityToSell, String sessionId) {
		QueryEngine queryEngine = getQueryEngine();

		// Get the Customers Group ID
		ResultSet userSet;
		try {
			userSet = getGroupIdFromCustomerId(customerId, queryEngine);
			int userGroupId = userSet.getInt("group_id");
			double userBalance = userSet.getDouble("balance");
			// Select All bond data from Bonds table which corresponds to the
			// required bond.
			ResultSet bondReq = queryEngine.query(
					"select * from bonds where cusip=? and group_id=?", cusip,
					String.valueOf(userGroupId));
			bondReq.first();
			// If the Available quantity is greater than equal to the requested
			// number - let the order go through
			int availableQuantity = bondReq.getInt("quantity_owned");
			if (availableQuantity >= Integer.parseInt(quantityToSell)) {
				availableQuantity = availableQuantity
						- Integer.parseInt(quantityToSell); // Get the
				// updated
				// Bonds.
			} else {
				return new ConfirmationData(2);
			}

			// Update Bonds table to reflect that the bonds are now processing -
			// reduce the quantity - For the Market! group_id=0
			queryEngine
					.getConnectionEngine()
					.update("update bonds set quantity_owned=quantity_owned+? where cusip=? and group_id=0",
							String.valueOf(quantityToSell), cusip);

			// Update the Quantity in the Customer's Bond data - Reduce it.
			queryEngine
					.getConnectionEngine()
					.update("update bonds set quantity_owned=? where cusip=? and group_id=?",
							String.valueOf(availableQuantity), cusip,
							String.valueOf(userGroupId));

			// Update User balance
			double bondPrice = bondReq.getDouble("price");
			userBalance = userBalance
					+ (bondPrice * Integer.parseInt(quantityToSell));

			// update Customer's Balance with the new balance.
			queryEngine.getConnectionEngine().update(
					"update customers c set c.balance=? where c.id=?",
					String.valueOf(userBalance), customerId);

			// Get Trader ID
			int traderId = queryEngine.getTraderIdFromSessionId(sessionId);
			// Get the current Date Time
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			String transactionUpdateQuery = "INSERT INTO transactions (buyer_id, seller_id, trader_id, transaction_date, bond_cusip, quantity, transaction_status) VALUES (?,?,?,?,?,?,?)";
			queryEngine.getConnectionEngine().update(transactionUpdateQuery,
					"0", String.valueOf(userGroupId), String.valueOf(traderId),
					currentTime, cusip, quantityToSell, "0");
			return new ConfirmationData(1, currentTime);

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;

	}

}