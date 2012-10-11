package com.db.training.blb;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;

public class BondModule {
	
	public ResultSet getListOfBonds(double couponRateLow, double couponRateHigh) throws SQLException {
		QueryEngine queryEngine = null;;
		try {
			queryEngine = new QueryEngine(new ConnectionEngine());
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		ResultSet rs = queryEngine.query("select * from blb.bonds where coupon_rate between " + couponRateLow + "and " + couponRateHigh);
		if(!rs.next()){
			return null;
		}
		return rs;
	}
	
	
	
}