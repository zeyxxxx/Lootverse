package model.dettaglioOrdine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.DriverManagerConnectionPool;

public class DettaglioOrdineDAO {

    private static final String TABLE_NAME = "dettaglio_ordine";

    public void doSave(DettaglioOrdineBean dettaglio) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (id_ordine, id_prodotto, prezzo, iva, quantita) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(insertSQL);

            preparedStatement.setInt(1, dettaglio.getIdOrdine());
            preparedStatement.setInt(2, dettaglio.getIdProdotto());
            preparedStatement.setDouble(3, dettaglio.getPrezzo());
            preparedStatement.setDouble(4, dettaglio.getIva());
            preparedStatement.setInt(5, dettaglio.getQuantita());

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public DettaglioOrdineBean doRetrieveById(int idOrdine, int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT id_ordine, id_prodotto, prezzo, iva, quantita "
                + "FROM " + TABLE_NAME
                + " WHERE id_ordine = ? AND id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idOrdine);
            preparedStatement.setInt(2, idProdotto);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractDettaglioOrdine(resultSet);
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

    public List<DettaglioOrdineBean> doRetrieveByOrdine(int idOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<DettaglioOrdineBean> dettagli = new ArrayList<DettaglioOrdineBean>();

        String selectSQL = "SELECT id_ordine, id_prodotto, prezzo, iva, quantita "
                + "FROM " + TABLE_NAME
                + " WHERE id_ordine = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idOrdine);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                dettagli.add(extractDettaglioOrdine(resultSet));
            }

            return dettagli;

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

    public List<DettaglioOrdineBean> doRetrieveByProdotto(int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<DettaglioOrdineBean> dettagli = new ArrayList<DettaglioOrdineBean>();

        String selectSQL = "SELECT id_ordine, id_prodotto, prezzo, iva, quantita "
                + "FROM " + TABLE_NAME
                + " WHERE id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idProdotto);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                dettagli.add(extractDettaglioOrdine(resultSet));
            }

            return dettagli;

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

    public void deleteByOrdine(int idOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_NAME
                + " WHERE id_ordine = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, idOrdine);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public void deleteProdottoFromOrdine(int idOrdine, int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_NAME
                + " WHERE id_ordine = ? AND id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, idOrdine);
            preparedStatement.setInt(2, idProdotto);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public double calcolaTotaleOrdine(int idOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT COALESCE(SUM(prezzo * quantita), 0) AS totale "
                + "FROM " + TABLE_NAME
                + " WHERE id_ordine = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idOrdine);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getDouble("totale");
            }

            return 0.0;

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

    private DettaglioOrdineBean extractDettaglioOrdine(ResultSet resultSet) throws SQLException {
        DettaglioOrdineBean dettaglio = new DettaglioOrdineBean();

        dettaglio.setIdOrdine(resultSet.getInt("id_ordine"));
        dettaglio.setIdProdotto(resultSet.getInt("id_prodotto"));
        dettaglio.setPrezzo(resultSet.getDouble("prezzo"));
        dettaglio.setIva(resultSet.getDouble("iva"));
        dettaglio.setQuantita(resultSet.getInt("quantita"));

        return dettaglio;
    }
}