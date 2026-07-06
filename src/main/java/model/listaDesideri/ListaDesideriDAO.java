package model.listaDesideri;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.DriverManagerConnectionPool;

public class ListaDesideriDAO {

    private static final String TABLE_NAME = "lista_desideri";
    private static final String TABLE_INCLUDE = "`include`";

    public void doSave(ListaDesideriBean lista) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME
                + " (prodotti, id_utente) VALUES (?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(
                    insertSQL,
                    PreparedStatement.RETURN_GENERATED_KEYS
            );

            preparedStatement.setInt(1, lista.getProdotti());
            preparedStatement.setInt(2, lista.getIdUtente());

            preparedStatement.executeUpdate();

            generatedKeys = preparedStatement.getGeneratedKeys();

            if (generatedKeys.next()) {
                lista.setIdListaDesideri(generatedKeys.getInt(1));
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

    public ListaDesideriBean creaListaPerUtente(int idUtente) throws SQLException {
        ListaDesideriBean listaEsistente = doRetrieveByUtente(idUtente);

        if (listaEsistente != null) {
            return listaEsistente;
        }

        ListaDesideriBean nuovaLista = new ListaDesideriBean();
        nuovaLista.setIdUtente(idUtente);
        nuovaLista.setProdotti(0);

        doSave(nuovaLista);

        return nuovaLista;
    }

    public ListaDesideriBean doRetrieveById(int idListaDesideri) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT id_lista_desideri, prodotti, id_utente "
                + "FROM " + TABLE_NAME
                + " WHERE id_lista_desideri = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idListaDesideri);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractListaDesideri(resultSet);
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

    public ListaDesideriBean doRetrieveByUtente(int idUtente) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT id_lista_desideri, prodotti, id_utente "
                + "FROM " + TABLE_NAME
                + " WHERE id_utente = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idUtente);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return extractListaDesideri(resultSet);
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

    public void aggiungiProdotto(int idLista, int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT IGNORE INTO " + TABLE_INCLUDE
                + " (id_lista, id_prodotto) VALUES (?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(insertSQL);
            preparedStatement.setInt(1, idLista);
            preparedStatement.setInt(2, idProdotto);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }

        aggiornaNumeroProdotti(idLista);
    }

    public void rimuoviProdotto(int idLista, int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_INCLUDE
                + " WHERE id_lista = ? AND id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, idLista);
            preparedStatement.setInt(2, idProdotto);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }

        aggiornaNumeroProdotti(idLista);
    }

    public boolean prodottoGiaPresente(int idLista, int idProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT id_prodotto "
                + "FROM " + TABLE_INCLUDE
                + " WHERE id_lista = ? AND id_prodotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idLista);
            preparedStatement.setInt(2, idProdotto);

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

    public void svuotaLista(int idLista) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String deleteSQL = "DELETE FROM " + TABLE_INCLUDE
                + " WHERE id_lista = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, idLista);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }

        aggiornaNumeroProdotti(idLista);
    }

    public int contaProdotti(int idLista) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT COUNT(*) AS totaleProdotti "
                + "FROM " + TABLE_INCLUDE
                + " WHERE id_lista = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idLista);

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

    public void aggiornaNumeroProdotti(int idLista) throws SQLException {
        int numeroProdotti = contaProdotti(idLista);

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String updateSQL = "UPDATE " + TABLE_NAME
                + " SET prodotti = ? "
                + "WHERE id_lista_desideri = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(updateSQL);
            preparedStatement.setInt(1, numeroProdotti);
            preparedStatement.setInt(2, idLista);

            preparedStatement.executeUpdate();

        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DriverManagerConnectionPool.releaseConnection(connection);
        }
    }

    private ListaDesideriBean extractListaDesideri(ResultSet resultSet) throws SQLException {
        ListaDesideriBean lista = new ListaDesideriBean();

        lista.setIdListaDesideri(resultSet.getInt("id_lista_desideri"));
        lista.setProdotti(resultSet.getInt("prodotti"));
        lista.setIdUtente(resultSet.getInt("id_utente"));

        return lista;
    }
}