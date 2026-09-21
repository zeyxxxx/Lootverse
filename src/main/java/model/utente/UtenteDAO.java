package model.utente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.DriverManagerConnectionPool;

/*
 DAO per la gestione degli Utenti registrati.
 Gestisce la registrazione, ricerca e login dei clienti sulla tabella 'utente'.
*/
public class UtenteDAO {
    private static final String TABLE_NAME = "utente";

    /*
     Salva un nuovo utente nel database durante la registrazione.
     Prende in input i dati inseriti nel form (email, password cifrata, nome, cognome, telefono).
     Dopo il salvataggio recupera l'ID numerico generato da MySQL e lo assegna all'utente.
    */
    public void doSave(UtenteBean utente) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (email, password_hash, nome, cognome, telefono) VALUES (?, ?, ?, ?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL, PreparedStatement.RETURN_GENERATED_KEYS);

            preparedStatement.setString(1, utente.getEmail());
            preparedStatement.setString(2, utente.getPasswordHash());
            preparedStatement.setString(3, utente.getNome());
            preparedStatement.setString(4, utente.getCognome());
            preparedStatement.setString(5, utente.getTelefono());

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

    /*
     Cerca e recupera il profilo completo di un utente partendo dalla sua email.
     Restituisce l'oggetto UtenteBean se trovato, altrimenti restituisce null.
    */
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

    /*
     Verifica se un indirizzo email è già registrato nel database.
     Utilizzato per il controllo istantaneo (AJAX) durante la digitazione nel form.
     Restituisce true se l'email esiste già, false se è libera.
    */
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

    /*
     Esegue il login verificando la corrispondenza tra email e password cifrata.
     Se i dati sono corretti restituisce l'UtenteBean autenticato, altrimenti restituisce null.
    */
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

    /*
     Recupera i dati di un utente partendo dalla sua chiave primaria (idUtente).
     Restituisce l'oggetto UtenteBean se trovato, oppure null.
    */
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

    /*
     Metodo di supporto interno: legge i campi dal database (ResultSet)
     e popola un oggetto UtenteBean pronto per l'uso.
    */
    private UtenteBean extractUtente(ResultSet resultSet) throws SQLException {
        UtenteBean utente = new UtenteBean();

        utente.setIdUtente(resultSet.getInt("idUtente"));
        utente.setEmail(resultSet.getString("email"));
        utente.setPasswordHash(resultSet.getString("password_hash"));
        utente.setNome(resultSet.getString("nome"));
        utente.setCognome(resultSet.getString("cognome"));
        utente.setTelefono(resultSet.getString("telefono"));

        return utente;
    }
}