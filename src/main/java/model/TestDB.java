package model;

import java.sql.Connection;

public class TestDB {
	 
	public static void main(String[] args) {
	        try {
	            Connection con = DriverManagerConnectionPool.getConnection();

	            if (con != null) {
	                System.out.println("CONNESSIONE AL DATABASE RIUSCITA");
	            }

	            DriverManagerConnectionPool.releaseConnection(con);

	        } catch (Exception e) {
	            System.out.println("CONNESSIONE AL DATABASE FALLITA");
	            e.printStackTrace();
	        }
	    }
}
