package model.ordine;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.DriverManagerConnectionPool;

public class OrdineDAO {

    private static final String TABLE_NAME = "ordine";

    public void doSave(OrdineBean ordine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (id_utente, stato, data, totale) VALUES (?, ?, ?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(
                    insertSQL,
                    Statement.RETURN_GENERATED_KEYS
            );

            preparedStatement.setInt(1, ordine.getIdUtente());

            if (ordine.getStato() != null) {
                preparedStatement.setString(2, ordine.getStato());
            } else {
                preparedStatement.setString(2, "In lavorazione");
            }

            if (ordine.getData() != null) {
                preparedStatement.setDate(3, Date.valueOf(ordine.getData()));
            } else {
                preparedStatement.setNull(3, Types.DATE);
            }

            preparedStatement.setDouble(4, ordine.getTotale());

            preparedStatement.executeUpdate();

            generatedKeys = preparedStatement.getGeneratedKeys();

            if (generatedKeys.next()) {
                ordine.setIdOrdine(generatedKeys.getInt(1));
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

    public OrdineBean doRetrieveById(int idOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT idOrdine, id_utente, stato, data, totale "
                + "FROM " + TABLE_NAME
                + " WHERE idOrdine = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idOrdine);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractOrdine(resultSet);
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

    public List<OrdineBean> doRetrieveByUtente(int idUtente) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<OrdineBean> ordini = new ArrayList<OrdineBean>();

        String selectSQL = "SELECT idOrdine, id_utente, stato, data, totale "
                + "FROM " + TABLE_NAME
                + " WHERE id_utente = ? "
                + "ORDER BY data DESC, idOrdine DESC";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idUtente);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ordini.add(extractOrdine(resultSet));
            }

            return ordini;

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

    public List<OrdineBean> doRetrieveAll() throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<OrdineBean> ordini = new ArrayList<OrdineBean>();

        String selectSQL = "SELECT idOrdine, id_utente, stato, data, totale "
                + "FROM " + TABLE_NAME
                + " ORDER BY data DESC, idOrdine DESC";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ordini.add(extractOrdine(resultSet));
            }

            return ordini;

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

    public List<OrdineBean> doRetrieveByStato(String stato) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<OrdineBean> ordini = new ArrayList<OrdineBean>();

        String selectSQL = "SELECT idOrdine, id_utente, stato, data, totale "
                + "FROM " + TABLE_NAME
                + " WHERE stato = ? "
                + "ORDER BY data DESC, idOrdine DESC";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, stato);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ordini.add(extractOrdine(resultSet));
            }

            return ordini;

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

    public List<OrdineBean> doRetrieveByDate(LocalDate dataInizio, LocalDate dataFine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<OrdineBean> ordini = new ArrayList<OrdineBean>();

        String selectSQL = "SELECT idOrdine, id_utente, stato, data, totale "
                + "FROM " + TABLE_NAME
                + " WHERE data BETWEEN ? AND ? "
                + "ORDER BY data DESC, idOrdine DESC";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setDate(1, Date.valueOf(dataInizio));
            preparedStatement.setDate(2, Date.valueOf(dataFine));

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ordini.add(extractOrdine(resultSet));
            }

            return ordini;

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

    public void updateStato(int idOrdine, String nuovoStato) throws SQLException {
        if (!isStatoValido(nuovoStato)) {
            throw new IllegalArgumentException("Stato ordine non valido: " + nuovoStato);
        }

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String updateSQL = "UPDATE " + TABLE_NAME
                + " SET stato = ? "
                + "WHERE idOrdine = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(updateSQL);
            preparedStatement.setString(1, nuovoStato);
            preparedStatement.setInt(2, idOrdine);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public void updateTotale(int idOrdine, double nuovoTotale) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String updateSQL = "UPDATE " + TABLE_NAME
                + " SET totale = ? "
                + "WHERE idOrdine = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(updateSQL);
            preparedStatement.setDouble(1, nuovoTotale);
            preparedStatement.setInt(2, idOrdine);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    public void deleteOrdine(int idOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_NAME
                + " WHERE idOrdine = ?";

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

    private OrdineBean extractOrdine(ResultSet resultSet) throws SQLException {
        OrdineBean ordine = new OrdineBean();

        ordine.setIdOrdine(resultSet.getInt("idOrdine"));
        ordine.setIdUtente(resultSet.getInt("id_utente"));
        ordine.setStato(resultSet.getString("stato"));
        ordine.setTotale(resultSet.getDouble("totale"));

        Date sqlDate = resultSet.getDate("data");

        if (sqlDate != null) {
            ordine.setData(sqlDate.toLocalDate());
        }

        return ordine;
    }

    private boolean isStatoValido(String stato) {
        return "In lavorazione".equals(stato)
                || "Spedito".equals(stato)
                || "Consegnato".equals(stato)
                || "Annullato".equals(stato)
                || "Rimborsato".equals(stato);
    }
}