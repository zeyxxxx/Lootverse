package model.utente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.DriverManagerConnectionPool;

public class UtenteDAO {
    private static final String TABLE_NAME = "utente";

    public void doSave(UtenteBean utente) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        // ➕ Query aggiornata con il campo telefono
        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (email, password_hash, nome, cognome, telefono) VALUES (?, ?, ?, ?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL, PreparedStatement.RETURN_GENERATED_KEYS);

            preparedStatement.setString(1, utente.getEmail());
            preparedStatement.setString(2, utente.getPasswordHash());
            preparedStatement.setString(3, utente.getNome());
            preparedStatement.setString(4, utente.getCognome());
            preparedStatement.setString(5, utente.getTelefono()); // ➕ Parametro 5

            preparedStatement.executeUpdate();

            ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
            if (generatedKeys.next()) {
                utente.setIdUtente(generatedKeys.getInt(1));
            }
            generatedKeys.close();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public UtenteBean doRetrieveByEmail(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idUtente, email, password_hash, nome, cognome, telefono "
                + "FROM " + TABLE_NAME + " WHERE email = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);

            preparedStatement.setString(1, email);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractUtente(resultSet);
            }

            return null;

        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public boolean emailExists(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idUtente FROM " + TABLE_NAME + " WHERE email = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);

            preparedStatement.setString(1, email);

            resultSet = preparedStatement.executeQuery();

            return resultSet.next();

        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public UtenteBean doLogin(String email, String passwordHash) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idUtente, email, password_hash, nome, cognome, telefono "
                + "FROM " + TABLE_NAME
                + " WHERE email = ? AND password_hash = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);

            preparedStatement.setString(1, email);
            preparedStatement.setString(2, passwordHash);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractUtente(resultSet);
            }

            return null;

        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public UtenteBean doRetrieveById(int id) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idUtente, email, password_hash, nome, cognome, telefono "
                + "FROM " + TABLE_NAME
                + " WHERE idUtente = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);

            preparedStatement.setInt(1, id);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractUtente(resultSet);
            }

            return null;

        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    private UtenteBean extractUtente(ResultSet resultSet) throws SQLException {
        UtenteBean utente = new UtenteBean();

        utente.setIdUtente(resultSet.getInt("idUtente"));
        utente.setEmail(resultSet.getString("email"));
        utente.setPasswordHash(resultSet.getString("password_hash"));
        utente.setNome(resultSet.getString("nome"));
        utente.setCognome(resultSet.getString("cognome"));
        utente.setTelefono(resultSet.getString("telefono")); // ➕ Lettura telefono

        return utente;
    }
}