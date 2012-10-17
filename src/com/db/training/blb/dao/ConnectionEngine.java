package com.db.training.blb.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.mysql.jdbc.PreparedStatement;

public class ConnectionEngine{
	
	private Connection connection;
	private Statement statement;
	private ResultSet resultSet;
	
	public synchronized Connection connect() throws ClassNotFoundException,SQLException{
		if(connection!=null || statement!=null){
			return connection;
		}
		connection = ConnectionInstance.getInstance().getConnection();
		statement=connection.createStatement();
		return connection;
	}
	
	public void update(String query) throws SQLException{
		statement.executeUpdate(query);
	}
	
	public void update(String query, String... args) throws SQLException{
		connection.setAutoCommit(false);
		java.sql.PreparedStatement statement=connection.prepareStatement(query);
		if(args.length>0){
			for (int i = 0; i < args.length; i++) {
				statement.setString(i+1, args[i]);

			}
		}
		statement.executeUpdate();
		connection.commit();
	}
	
	public ResultSet query(String query) throws SQLException{
		  resultSet = statement.executeQuery(query);
		  return resultSet;
	}
	
	public ResultSet query(String query, String... args) throws SQLException{
		connection.setAutoCommit(false);
		java.sql.PreparedStatement statement=connection.prepareStatement(query);
		if(args.length>0){
			for (int i = 0; i < args.length; i++) {
				statement.setString(i+1, args[i]);

			}
		}
		resultSet = statement.executeQuery();
		connection.commit();
		return resultSet;
	}
	
	public void close() throws SQLException {
		statement.close();
	}
	
	@Override
	public void finalize(){
		try {
			resultSet.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
}
