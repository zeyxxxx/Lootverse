package model.carrello;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import model.DriverManagerConnectionPool;

public class CarrelloDAO {

    private static final String TABLE_NAME = "carrello";
    private static final String TABLE_CONTIENE = "contiene";

    public void doSave(CarrelloBean carrello) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (data, id_utente) VALUES (?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(
                    insertSQL,
                    PreparedStatement.RETURN_GENERATED_KEYS
            );

            if (carrello.getData() != null) {
                preparedStatement.setDate(1, Date.valueOf(carrello.getData()));
            } else {
                preparedStatement.setNull(1, Types.DATE);
            }

            preparedStatement.setInt(2, carrello.getIdUtente());

            preparedStatement.executeUpdate();

            generatedKeys = preparedStatement.getGeneratedKeys();

            if (generatedKeys.next()) {
                carrello.setIdCarrello(generatedKeys.getInt(1));
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

    public CarrelloBean creaCarrelloPerUtente(int idUtente) throws SQLException {
        CarrelloBean carrelloEsistente = doRetrieveByUtente(idUtente);

        if (carrelloEsistente != null) {
            return carrelloEsistente;
        }

        CarrelloBean nuovoCarrello = new CarrelloBean();
        nuovoCarrello.setIdUtente(idUtente);
        nuovoCarrello.setData(LocalDate.now());

        doSave(nuovoCarrello);

        return nuovoCarrello;
    }

    public CarrelloBean doRetrieveById(int idCarrello) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idCarrello, data, id_utente "
                + "FROM " + TABLE_NAME
                + " WHERE idCarrello = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idCarrello);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractCarrello(resultSet);
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

    public CarrelloBean doRetrieveByUtente(int idUtente) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idCarrello, data, id_utente "
                + "FROM " + TABLE_NAME
                + " WHERE id_utente = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idUtente);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractCarrello(resultSet);
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

    public void aggiungiProdotto(int idCarrello, int idProdotto, int quantita) throws SQLException {
        if (quantita <= 0) {
            throw new IllegalArgumentException("La quantitÃ  deve essere maggiore di zero.");
        }

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO " + TABLE_CONTIENE
                + " (id_carrello, id_prodotto, quantita) VALUES (?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE quantita = quantita + VALUES(quantita)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(insertSQL);
            preparedStatement.setInt(1, idCarrello);
            preparedStatement.setInt(2, idProdotto);
            preparedStatement.setInt(3, quantita);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public void rimuoviProdotto(int idCarrello, int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_CONTIENE
                + " WHERE id_carrello = ? AND id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, idCarrello);
            preparedStatement.setInt(2, idProdotto);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public void modificaQuantita(int idCarrello, int idProdotto, int quantita) throws SQLException {
        if (quantita <= 0) {
            rimuoviProdotto(idCarrello, idProdotto);
            return;
        }

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String updateSQL = "UPDATE " + TABLE_CONTIENE
                + " SET quantita = ? "
                + "WHERE id_carrello = ? AND id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(updateSQL);
            preparedStatement.setInt(1, quantita);
            preparedStatement.setInt(2, idCarrello);
            preparedStatement.setInt(3, idProdotto);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public void svuotaCarrello(int idCarrello) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_CONTIENE
                + " WHERE id_carrello = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, idCarrello);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public Collection<ContieneBean> doRetrieveProdotti(int idCarrello) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        Collection<ContieneBean> prodottiCarrello = new ArrayList<>();

        String selectSQL = "SELECT id_carrello, id_prodotto, quantita "
                + "FROM " + TABLE_CONTIENE
                + " WHERE id_carrello = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idCarrello);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ContieneBean contiene = new ContieneBean();

                contiene.setIdCarrello(resultSet.getInt("id_carrello"));
                contiene.setIdProdotto(resultSet.getInt("id_prodotto"));
                contiene.setQuantita(resultSet.getInt("quantita"));

                prodottiCarrello.add(contiene);
            }

            return prodottiCarrello;

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
    
    public int contaProdotti(int idCarrello) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT COALESCE(SUM(quantita), 0) AS totaleProdotti "
                + "FROM " + TABLE_CONTIENE
                + " WHERE id_carrello = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idCarrello);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("totaleProdotti");
            }

            return 0;

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

    private CarrelloBean extractCarrello(ResultSet resultSet) throws SQLException {
        CarrelloBean carrello = new CarrelloBean();

        carrello.setIdCarrello(resultSet.getInt("idCarrello"));
        carrello.setIdUtente(resultSet.getInt("id_utente"));

        Date sqlDate = resultSet.getDate("data");

        if (sqlDate != null) {
            carrello.setData(sqlDate.toLocalDate());
        }

        return carrello;
    }
}