package com.db.training.blb;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;

public class BondModule {
	
	public ResultSet getListOfBonds(String couponRateLow, String couponRateHigh) throws SQLException {
		QueryEngine queryEngine = null;;
		try {
			queryEngine = new QueryEngine(new ConnectionEngine());
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		ResultSet rs = queryEngine.query("select * from blb.bonds where coupon_rate between ? and ? and group_id=0", couponRateLow, couponRateHigh);
		if(!rs.next()){
			return null;
		}
		return rs;
	}
	
	public boolean processBondOrder(String cusip) {
		QueryEngine queryEngine = null;;
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
			ResultSet bondReq = queryEngine.query("select * from bonds where cusip=? and group_id=0", cusip);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return false;
	}
	
}