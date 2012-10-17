package com.db.training.blb.test;

import static org.junit.Assert.*;

import java.sql.SQLException;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;

public class QueryEngineTest {

	QueryEngine engine;
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
		engine = new QueryEngine(new ConnectionEngine());
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testGetConnectionEngine() {
		assertTrue(engine.getConnectionEngine() != null);
	}
	
	@Test
	public void testGetBondDataPositive() {
		try {
			assertTrue(engine.getBondData("0088a4567") != null);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Test
	public void testGetBondDataNegative() {
		try {
			assertTrue(engine.getBondData("0088a457") == null);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
