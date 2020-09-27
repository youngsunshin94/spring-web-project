package com.mycom.persistance;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

import lombok.extern.log4j.Log4j;

@Log4j
public class JDBCTests {

	@Test
	public void setUp() throws Exception {
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		try(Connection con = DriverManager.getConnection(
				"",
				"",
				"")) {
			log.info(con);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
