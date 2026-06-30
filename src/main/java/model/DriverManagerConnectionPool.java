package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DriverManagerConnectionPool {
	private static final String URL = "jdbc:mysql://localhost:3306/lootverse_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	private static final String USER = "root";
    private static final String PASSWORD = "pOEIEW1nVVb2qG";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver MySQL caricato correttamente.");
        } catch (ClassNotFoundException e) {
            System.out.println("Errore: Driver MySQL non trovato.");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void releaseConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connessione chiusa correttamente.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
