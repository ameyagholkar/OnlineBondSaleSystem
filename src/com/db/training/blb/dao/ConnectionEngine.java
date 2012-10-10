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
		Class.forName("com.mysql.jdbc.Driver");// Step 1. Load the JDBC driver
		connection = DriverManager.getConnection( "jdbc:mysql://127.0.0.1:3306/blb",  "root", "password");// Step 1. Load the JDBC driver
		statement=connection.createStatement();
		return connection;
	}
	
	public void update(String query) throws SQLException{
		statement.executeUpdate(query);
	}
	
	public ResultSet query(String query) throws SQLException{
		  resultSet = statement.executeQuery(query);
		  return resultSet;
	}
	
	public void close() throws SQLException {
		statement.close();
		connection.close();
	}
	
}
