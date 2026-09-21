package model.dettaglioOrdine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.DriverManagerConnectionPool;

/*
 DAO per la gestione delle singole righe di dettaglio d'ordine.
 Gestisce la tabella 'dettaglio_ordine', memorizzando prezzo storico al momento dell'acquisto, IVA e quantita.
*/
public class DettaglioOrdineDAO {

    private static final String TABLE_NAME = "dettaglio_ordine";

    /*
     Salva una singola riga d'ordine (prodotto, prezzo bloccato all'acquisto, IVA e quantita) nel database.
     Prende in input l'oggetto DettaglioOrdineBean.
    */
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

    /*
     Recupera una specifica riga di dettaglio tramite la chiave primaria composta (idOrdine, idProdotto).
     Restituisce l'oggetto DettaglioOrdineBean se trovato, altrimenti restituisce null.
    */
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

    /*
     Recupera tutte le righe di dettaglio associate a un determinato ordine.
     Utilizzato per mostrare l'elenco dei prodotti acquistati nella pagina di riepilogo ordine.
     Restituisce una lista di oggetti DettaglioOrdineBean.
    */
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

    /*
     Recupera tutti i dettagli d'ordine in cui compare uno specifico prodotto.
     Restituisce una lista di oggetti DettaglioOrdineBean.
    */
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

    /*
     Elimina tutte le righe di dettaglio appartenenti a un determinato ordine.
     Prende in input l'ID dell'ordine.
    */
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

    /*
     Elimina un singolo prodotto acquistato da un ordine specifico.
     Prende in input l'ID dell'ordine e l'ID del prodotto.
    */
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

    /*
     Ricalcola la somma totale (prezzo unitario * quantita) di tutte le righe dell'ordine.
     Restituisce l'importo totale calcolato direttamente dal database con la funzione SUM.
    */
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

    /*
     Metodo di supporto interno: estrae i valori dalla riga del database (ResultSet)
     e li inserisce in un oggetto DettaglioOrdineBean pronto all'uso.
    */
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