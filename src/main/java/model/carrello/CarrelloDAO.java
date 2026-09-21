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

/*
 DAO per la gestione del Carrello della spesa e della tabella ponte 'contiene'.
 Fornisce operazioni per creare il carrello utente, aggiungere prodotti, modificare quantita e svuotarlo.
*/
public class CarrelloDAO {

    private static final String TABLE_NAME = "carrello";
    private static final String TABLE_CONTIENE = "contiene";

    /*
     Inserisce una nuova testata carrello per un utente nel database.
     Prende in input l'oggetto carrello con data e idUtente.
     Recupera l'ID generato automaticamente da MySQL e lo assegna al carrello.
    */
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

    /*
     Garantisce che l'utente abbia un carrello: se esiste gia lo restituisce,
     altrimenti ne crea uno nuovo associato al suo ID e lo salva nel database.
    */
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

    /*
     Recupera un carrello partendo dal suo ID univoco (chiave primaria).
     Restituisce l'oggetto CarrelloBean se trovato, oppure null se non esiste.
    */
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

    /*
     Cerca il carrello associato a un utente tramite il suo idUtente.
     Restituisce il CarrelloBean corrispondente, oppure null se l'utente non ne possiede uno.
    */
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

    /*
     Aggiunge un prodotto al carrello (nella tabella ponte 'contiene').
     Prende in input l'ID del carrello, l'ID del prodotto e la quantita.
     Se il prodotto e gia presente nel carrello, ne incrementa la quantita.
    */
    public void aggiungiProdotto(int idCarrello, int idProdotto, int quantita) throws SQLException {
        if (quantita <= 0) {
            throw new IllegalArgumentException("La quantita deve essere maggiore di zero.");
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

    /*
     Rimuove un prodotto dal carrello (cancella il record nella tabella 'contiene').
     Prende in input l'ID del carrello e l'ID del prodotto da rimuovere.
    */
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

    /*
     Modifica la quantita acquistata di un determinato prodotto nel carrello.
     Se la nuova quantita e minore o uguale a zero, il prodotto viene direttamente eliminato dal carrello.
    */
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

    /*
     Svuota completamente il carrello cancellando tutti i prodotti presenti nella tabella 'contiene'.
     Prende in input l'ID del carrello.
    */
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

    /*
     Recupera l'elenco di tutti i prodotti presenti nel carrello con le rispettive quantita.
     Restituisce una lista (Collection) di oggetti ContieneBean.
    */
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
    
    /*
     Calcola il numero totale di pezzi (somma di tutte le quantita) presenti nel carrello.
     Utile per aggiornare il numeretto dell'icona del carrello nella barra di navigazione.
    */
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

    /*
     Metodo di supporto interno: legge i dati dalla riga del database (ResultSet)
     e li inserisce in un oggetto CarrelloBean.
    */
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