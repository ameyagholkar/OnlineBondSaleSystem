package com.db.training.blb.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionInstance {

	private static ConnectionInstance instance;
	private Connection connection;

	private ConnectionInstance() throws ClassNotFoundException, SQLException{
		Class.forName("com.mysql.jdbc.Driver");// Step 1. Load the JDBC driver
		connection = DriverManager.getConnection( "jdbc:mysql://127.0.0.1:3306/blb",  "root", "password");// Step 1. Load the JDBC driver
	}
	
	public static synchronized ConnectionInstance getInstance() throws ClassNotFoundException, SQLException{
		if(instance==null){
			instance=new ConnectionInstance();
		}
		return instance;
	}
	
	public Connection getConnection() {
		return connection;
	}

	@Override
	protected void finalize() throws Throwable {
		connection.close();
	}
	
	
}
