package model.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.DriverManagerConnectionPool;

/*
 DAO per la gestione degli Amministratori.
 Incapsula tutte le operazioni CRUD e di autenticazione sulla tabella 'admin'.
*/
public class AdminDAO {

    private static final String TABLE_NAME = "admin";

    /*
     Salva un nuovo amministratore nel database.
     Prende in input l'oggetto admin con nome, email e password cifrata.
     Dopo l'inserimento, recupera l'ID numerico generato da MySQL e lo assegna all'oggetto.
    */
    public void doSave(AdminBean admin) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (nome, email, password_hash) VALUES (?, ?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(
                    insertSQL,
                    PreparedStatement.RETURN_GENERATED_KEYS
            );

            preparedStatement.setString(1, admin.getNome());
            preparedStatement.setString(2, admin.getEmail());
            preparedStatement.setString(3, admin.getPasswordHash());

            preparedStatement.executeUpdate();

            generatedKeys = preparedStatement.getGeneratedKeys();

            if (generatedKeys.next()) {
                admin.setIdAdmin(generatedKeys.getInt(1));
            }

        } finally {
            if (generatedKeys != null) {
                generatedKeys.close();
            }

            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    /*
     Cerca un amministratore nel database tramite il suo indirizzo email.
     Restituisce l'oggetto AdminBean con tutti i dati se trovato, altrimenti restituisce null.
    */
    public AdminBean doRetrieveByEmail(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idAdmin, nome, email, password_hash "
                + "FROM " + TABLE_NAME
                + " WHERE email = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, email);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractAdmin(resultSet);
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

    /*
     Verifica se un indirizzo email appartiene già a un amministratore registrato.
     Restituisce true se l'email esiste già nel database, false se non è presente.
    */
    public boolean emailExists(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idAdmin FROM " + TABLE_NAME + " WHERE email = ?";

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

    /*
     Esegue l'accesso dell'amministratore controllando la combinazione di email e password cifrata.
     Se le credenziali sono corrette restituisce l'oggetto AdminBean, altrimenti restituisce null.
    */
    public AdminBean doLogin(String email, String passwordHash) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idAdmin, nome, email, password_hash "
                + "FROM " + TABLE_NAME
                + " WHERE email = ? AND password_hash = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, passwordHash);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractAdmin(resultSet);
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

    /*
     Recupera un amministratore tramite il suo ID numerico (chiave primaria).
     Restituisce l'oggetto AdminBean trovato, oppure null se non esiste.
    */
    public AdminBean doRetrieveById(int idAdmin) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idAdmin, nome, email, password_hash "
                + "FROM " + TABLE_NAME
                + " WHERE idAdmin = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idAdmin);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractAdmin(resultSet);
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

    /*
     Metodo di supporto interno: legge i dati dalla riga del database (ResultSet)
     e crea un oggetto AdminBean pronto da usare.
    */
    private AdminBean extractAdmin(ResultSet resultSet) throws SQLException {
        AdminBean admin = new AdminBean();

        admin.setIdAdmin(resultSet.getInt("idAdmin"));
        admin.setNome(resultSet.getString("nome"));
        admin.setEmail(resultSet.getString("email"));
        admin.setPasswordHash(resultSet.getString("password_hash"));

        return admin;
    }
}