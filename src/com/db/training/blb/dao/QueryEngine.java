package com.db.training.blb.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.management.Query;

public class QueryEngine {
	private ConnectionEngine connectionEngine;
	
	public QueryEngine(){}
	public QueryEngine(ConnectionEngine connectionEngine) throws ClassNotFoundException, SQLException{
		this.connectionEngine=connectionEngine;
		this.connectionEngine.connect();
	}
	
	@Override
	protected void finalize() throws Throwable {
		this.connectionEngine.close();
	}

	public ConnectionEngine getConnectionEngine() {
		return connectionEngine;
	}

	public void setConnEng(ConnectionEngine connEng) {
		this.connectionEngine = connEng;
	}
	
	public String getUserForSessionId(String sessionId) throws SQLException{
		if(connectionEngine==null){
			throw new RuntimeException("No connection engine was provided!");
		}
		ResultSet rs=connectionEngine.query("select username from blb.login_session where session_id='"+sessionId.replaceAll("'", "")+"' and abs(TIMESTAMPDIFF(MINUTE,now(),timestamp(last_activity)))<=5 limit 1");
		if(!rs.next()){
			return null;
		}
		String user=rs.getString(1);
		connectionEngine.update("update login_session set last_activity=now() where username='"+user+"'");
		return user;
	}
	
	public boolean checkUserCredentials(String username, String password) throws SQLException{
		if(connectionEngine==null){
			throw new RuntimeException("No connection engine was provided!");
		}
		if(username==null || password==null){
			return false;
		}
		String user=username.replaceAll("'", "");
		String pass=password.replaceAll("'", "");
		ResultSet rs=connectionEngine.query("select count(t.username) from (select username  from blb.customers where username='"+user+"' and password_hash=md5('"+pass+"') union select username from blb.traders where username='"+user+"' and password_hash=md5('"+pass+"')) t");
		if(!rs.next()){
			return false;
		}else{
			if(rs.getInt(1)==1){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Returns SESSION
	 * @param username
	 * @return
	 * @throws SQLException
	 */
	public String createSession(String username) throws SQLException{
		if(connectionEngine==null){
			throw new RuntimeException("No connection engine was provided!");
		}
		connectionEngine.update("insert into login_session(session_id,username,last_activity) values (md5(concat('"+username+"',timestamp(now()))),'"+username+"',now())");
		ResultSet rs=connectionEngine.query("select session_id from login_session where username='"+username+"' and abs(TIMESTAMPDIFF(MINUTE,now(),timestamp(last_activity)))<=1 limit 1");
		if(!rs.next())
			return null;
		return rs.getString(1);
	}
	
	
	public ResultSet getListOfBonds() throws SQLException {
		if(connectionEngine==null){
			throw new RuntimeException("No connection engine was provided!");
		}
		
		ResultSet rs = connectionEngine.query("select * from blb.bonds");
		if(!rs.next()){
			return null;
		}
		return rs;
	}
	
	public ResultSet searchBonds() throws SQLException {
		if(connectionEngine==null){
			throw new RuntimeException("No connection engine was provided!");
		}
		
		ResultSet rs = connectionEngine.query("select * from blb.bonds");
		if(!rs.next()){
			return null;
		}
		return rs;
	}
	
}
