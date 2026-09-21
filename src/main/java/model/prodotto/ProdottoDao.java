package model.prodotto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;

import model.DriverManagerConnectionPool;

/*
 DAO per la gestione dei Prodotti.
 Fornisce operazioni per visualizzare il catalogo, ricerca asincrona, bestseller, inserimento, modifica ed eliminazione.
*/
public class ProdottoDao {

    private static final String TABLE_NAME = "prodotto";

    /*
     Recupera l'elenco completo di tutti i prodotti presenti nel database.
     Restituisce una collezione di oggetti ProdottoBean.
    */
    public synchronized Collection<ProdottoBean> doRetrieveAll() throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Collection<ProdottoBean> prodotti = new LinkedList<ProdottoBean>();

        String selectSQL = "SELECT * FROM " + TABLE_NAME;

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                ProdottoBean bean = new ProdottoBean();

                bean.setIdProdotto(rs.getInt("idProdotto"));
                bean.setPrezzo(rs.getDouble("prezzo"));
                bean.setDescrizione(rs.getString("descrizione"));
                bean.setDisponibilita(rs.getBoolean("disponibilita")); 
                bean.setSconto(rs.getDouble("sconto"));
                bean.setIva(rs.getDouble("iva"));
                bean.setId_admin(rs.getInt("id_admin"));
                bean.setNome(rs.getString("nome"));
                bean.setMateriale(rs.getString("materiale"));
                bean.setColore(rs.getString("colore"));
                bean.setDimensione(rs.getString("dimensione"));
                bean.setImmagine(rs.getString("immagine"));
                bean.setImmagineCarosello(rs.getString("immagine_carosello"));
                bean.setTipoArma(rs.getString("tipo_arma"));
                bean.setTipoMedia(rs.getString("tipo_media"));
                bean.setMondoProvenienza(rs.getString("mondo_provenienza"));

                prodotti.add(bean);
            }

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
        return prodotti;
    }

    /*
     Cerca un singolo prodotto tramite la sua chiave primaria (idProdotto).
     Restituisce l'oggetto ProdottoBean con tutte le informazioni, oppure null se non esiste.
    */
    public synchronized ProdottoBean doRetrieveById(int id) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ProdottoBean bean = null;

        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE idProdotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, id);

            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                bean = new ProdottoBean();
                bean.setIdProdotto(rs.getInt("idProdotto"));
                bean.setPrezzo(rs.getDouble("prezzo"));
                bean.setDescrizione(rs.getString("descrizione"));
                bean.setDisponibilita(rs.getBoolean("disponibilita"));
                bean.setSconto(rs.getDouble("sconto"));
                bean.setIva(rs.getDouble("iva"));
                bean.setId_admin(rs.getInt("id_admin"));
                bean.setNome(rs.getString("nome"));
                bean.setMateriale(rs.getString("materiale"));
                bean.setColore(rs.getString("colore"));
                bean.setDimensione(rs.getString("dimensione"));
                bean.setImmagine(rs.getString("immagine"));
                bean.setImmagineCarosello(rs.getString("immagine_carosello"));
                bean.setTipoArma(rs.getString("tipo_arma"));
                bean.setTipoMedia(rs.getString("tipo_media"));
                bean.setMondoProvenienza(rs.getString("mondo_provenienza"));
            }

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
        return bean;
    }

    /*
     Salva un nuovo prodotto nel database con tutte le sue caratteristiche.
     Prende in input l'oggetto ProdottoBean compilato nel form di inserimento admin.
    */
    public synchronized void doSave(ProdottoBean prodotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO " + TABLE_NAME 
                + " (prezzo, descrizione, disponibilita, sconto, iva, id_admin, nome, materiale, colore, dimensione, immagine, immagine_carosello, tipo_arma, tipo_media, mondo_provenienza) "
                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL);

            preparedStatement.setDouble(1, prodotto.getPrezzo());
            preparedStatement.setString(2, prodotto.getDescrizione());
            preparedStatement.setBoolean(3, prodotto.isDisponibilita());
            preparedStatement.setDouble(4, prodotto.getSconto());
            preparedStatement.setDouble(5, prodotto.getIva());
            preparedStatement.setInt(6, prodotto.getId_admin());
            preparedStatement.setString(7, prodotto.getNome());
            preparedStatement.setString(8, prodotto.getMateriale());
            preparedStatement.setString(9, prodotto.getColore());
            preparedStatement.setString(10, prodotto.getDimensione());
            preparedStatement.setString(11, prodotto.getImmagine());
            preparedStatement.setString(12, prodotto.getImmagineCarosello());
            preparedStatement.setString(13, prodotto.getTipoArma());
            preparedStatement.setString(14, prodotto.getTipoMedia());
            preparedStatement.setString(15, prodotto.getMondoProvenienza());

            preparedStatement.executeUpdate();

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
    }

    /*
     Aggiorna i dati di un prodotto esistente nel catalogo.
     Usa l'idProdotto dell'oggetto per individuare la riga da modificare.
    */
    public synchronized void doUpdate(ProdottoBean prodotto) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String updateSQL = "UPDATE " + TABLE_NAME + " SET "
                + " prezzo = ?, descrizione = ?, disponibilita = ?, sconto = ?, iva = ?, "
                + " id_admin = ?, nome = ?, materiale = ?, colore = ?, dimensione = ?, "
                + " immagine = ?, immagine_carosello = ?, tipo_arma = ?, tipo_media = ?, mondo_provenienza = ? "
                + " WHERE idProdotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(updateSQL);

            preparedStatement.setDouble(1, prodotto.getPrezzo());
            preparedStatement.setString(2, prodotto.getDescrizione());
            preparedStatement.setBoolean(3, prodotto.isDisponibilita());
            preparedStatement.setDouble(4, prodotto.getSconto());
            preparedStatement.setDouble(5, prodotto.getIva());
            preparedStatement.setInt(6, prodotto.getId_admin());
            preparedStatement.setString(7, prodotto.getNome());
            preparedStatement.setString(8, prodotto.getMateriale());
            preparedStatement.setString(9, prodotto.getColore());
            preparedStatement.setString(10, prodotto.getDimensione());
            preparedStatement.setString(11, prodotto.getImmagine());
            preparedStatement.setString(12, prodotto.getImmagineCarosello());
            preparedStatement.setString(13, prodotto.getTipoArma());
            preparedStatement.setString(14, prodotto.getTipoMedia());
            preparedStatement.setString(15, prodotto.getMondoProvenienza());
            preparedStatement.setInt(16, prodotto.getIdProdotto());

            preparedStatement.executeUpdate();

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
    }

    /*
     Elimina fisicamente un prodotto dal database tramite il suo ID numerico.
     Restituisce true se l'eliminazione ha avuto successo, false altrimenti.
    */
    public synchronized boolean doDelete(int id) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        int result = 0;

        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE idProdotto = ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(deleteSQL);
            preparedStatement.setInt(1, id);

            result = preparedStatement.executeUpdate();

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
        return (result != 0);
    }

    /*
     Esegue una ricerca asincrona per nome (utilizzata nella barra di ricerca live).
     Cerca i prodotti disponibili il cui nome contiene il testo digitato (max 10 risultati).
     Restituisce una collezione di ProdottoBean corrispondenti.
    */
    public synchronized Collection<ProdottoBean> doSearchByName(String query) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Collection<ProdottoBean> prodotti = new LinkedList<>();

        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE LOWER(nome) LIKE ? AND disponibilita = 1 LIMIT 10";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + query.toLowerCase().trim() + "%");

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                ProdottoBean bean = new ProdottoBean();
                bean.setIdProdotto(rs.getInt("idProdotto"));
                bean.setPrezzo(rs.getDouble("prezzo"));
                bean.setDescrizione(rs.getString("descrizione"));
                bean.setDisponibilita(rs.getBoolean("disponibilita"));
                bean.setSconto(rs.getDouble("sconto"));
                bean.setIva(rs.getDouble("iva"));
                bean.setId_admin(rs.getInt("id_admin"));
                bean.setNome(rs.getString("nome"));
                bean.setMateriale(rs.getString("materiale"));
                bean.setColore(rs.getString("colore"));
                bean.setDimensione(rs.getString("dimensione"));
                bean.setImmagine(rs.getString("immagine"));
                bean.setImmagineCarosello(rs.getString("immagine_carosello"));
                bean.setTipoArma(rs.getString("tipo_arma"));
                bean.setTipoMedia(rs.getString("tipo_media"));
                bean.setMondoProvenienza(rs.getString("mondo_provenienza"));

                prodotti.add(bean);
            }
        } finally {
            if (preparedStatement != null) preparedStatement.close();
            DriverManagerConnectionPool.releaseConnection(connection);
        }
        return prodotti;
    }

    /*
     Recupera i prodotti più venduti (Best Sellers) unendo le tabelle prodotto e dettaglio_ordine.
     Seleziona i prodotti con almeno 3 unità vendute in totale, ordinandoli per vendite decrescenti.
    */
    public synchronized Collection<ProdottoBean> doRetrieveBestSellers(int limit) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Collection<ProdottoBean> prodotti = new LinkedList<>();

        String selectSQL = "SELECT p.*, COALESCE(SUM(d.quantita), 0) as totale_vendite " +
                           "FROM " + TABLE_NAME + " p " +
                           "JOIN dettaglio_ordine d ON p.idProdotto = d.id_prodotto " +
                           "GROUP BY p.idProdotto " +
                           "HAVING totale_vendite >= 3 " +
                           "ORDER BY totale_vendite DESC " +
                           "LIMIT ?";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, limit);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                ProdottoBean bean = new ProdottoBean();
                bean.setIdProdotto(rs.getInt("idProdotto"));
                bean.setPrezzo(rs.getDouble("prezzo"));
                bean.setDescrizione(rs.getString("descrizione"));
                bean.setDisponibilita(rs.getBoolean("disponibilita"));
                bean.setSconto(rs.getDouble("sconto"));
                bean.setIva(rs.getDouble("iva"));
                bean.setId_admin(rs.getInt("id_admin"));
                bean.setNome(rs.getString("nome"));
                bean.setMateriale(rs.getString("materiale"));
                bean.setColore(rs.getString("colore"));
                bean.setDimensione(rs.getString("dimensione"));
                bean.setImmagine(rs.getString("immagine"));
                bean.setImmagineCarosello(rs.getString("immagine_carosello"));
                bean.setTipoArma(rs.getString("tipo_arma"));
                bean.setTipoMedia(rs.getString("tipo_media"));
                bean.setMondoProvenienza(rs.getString("mondo_provenienza"));

                prodotti.add(bean);
            }
        } finally {
            if (preparedStatement != null) preparedStatement.close();
            DriverManagerConnectionPool.releaseConnection(connection);
        }
        return prodotti;
    }

    /*
     Estrae tutti i valori univoci del campo 'mondo_provenienza' presenti a catalogo.
     Utilizzato per popolare automaticamente i pulsanti dei filtri nel catalogo.
    */
    public synchronized Collection<String> doRetrieveAllMondiProvenienza() throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Collection<String> mondi = new LinkedList<>();

        String selectSQL = "SELECT DISTINCT mondo_provenienza FROM " + TABLE_NAME + " WHERE mondo_provenienza IS NOT NULL AND mondo_provenienza != '' ORDER BY mondo_provenienza";

        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                mondi.add(rs.getString("mondo_provenienza"));
            }

        } finally {
            try {
                if (preparedStatement != null)
                    preparedStatement.close();
            } finally {
                DriverManagerConnectionPool.releaseConnection(connection);
            }
        }
        return mondi;
    }
}