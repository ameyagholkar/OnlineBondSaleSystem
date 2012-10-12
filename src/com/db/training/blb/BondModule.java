package com.db.training.blb;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;

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
						+ "where rating between ? and ? "
						+ "and coupon_rate between ? and ? "
						+ "and current_yield between ? and ? "
						+ "and maturity_yield between ? and ? "
						+ "and timestamp(maturity_date) between timestamp(?) and timestamp(?) "
						+ "and par_value between ? and ? "
						+ "and price between ? and ? "
						+ "and group_id=0 and quantity_owned > 0",
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

	public int processBondOrder(String cusip, String numOfBonds,
			String customerId, String totalPrice, String sessionId) {
		QueryEngine queryEngine = null;
		;
		try {
			queryEngine = new QueryEngine(new ConnectionEngine());
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		try {
			// Get the Customers Group ID
			ResultSet userSet = queryEngine
					.query("select g.id as group_id, c.balance as balance from customers c, groups g where g.group_type=1 and c.id=? and c.id = g.participant_id;",
							customerId);
			userSet.first();
			int userGroupId = userSet.getInt("group_id");
			double userBalance = userSet.getDouble("balance");
			// Select All bond data from Bonds table which corresponds to the
			// required bond.
			ResultSet bondReq = queryEngine.query(
					"select * from bonds where cusip=? and group_id=0", cusip);
			bondReq.first();
			// Check to ensure that the customer has the required balance
			if (userBalance < Double.parseDouble(totalPrice)) {
				return 3;
			} else {
				userBalance = userBalance - Double.parseDouble(totalPrice);
			}
			// If the Available quantity is greater than equal to the requested
			// number - let the order go through
			int availableQuantity = bondReq.getInt(10);
			if (availableQuantity >= Integer.parseInt(numOfBonds)) {
				availableQuantity = availableQuantity
						- Integer.parseInt(numOfBonds); // Get the
				// updated
				// Bonds.
			} else {
				return 2;
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
						.update("insert into bonds values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
								bondReq.getString("cusip"),
								String.valueOf(bondReq.getInt("rating")),
								String.valueOf(bondReq.getDouble("coupon_rate")),
								String.valueOf(bondReq
										.getDouble("current_yield")),
								String.valueOf(bondReq
										.getDouble("maturity_yield")),
								String.valueOf(bondReq.getDate("maturity_date")),
								String.valueOf(bondReq.getDouble("par_value")),
								String.valueOf(bondReq.getDouble("price")),
								String.valueOf(userGroupId), numOfBonds,
								bondReq.getString("bond_name"), bondReq.getString("issuer_name"),
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
			//Get Trader ID
			int traderId = queryEngine.getTraderIdFromSessionId(sessionId);
			// Get the current Date Time
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = 
			     new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			String transactionUpdateQuery = "INSERT INTO transactions (buyer_id, seller_id, trader_id, transaction_date, bond_cusip, quantity, transaction_status) VALUES (?,?,?,?,?,?,?)";
			queryEngine.getConnectionEngine().update(transactionUpdateQuery, customerId, String.valueOf(bondReq.getInt("group_id")), String.valueOf(traderId), currentTime, cusip, numOfBonds, "0" );
			return 1;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;
	}
}