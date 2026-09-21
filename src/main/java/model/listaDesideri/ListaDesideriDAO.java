package model.listaDesideri;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import model.DriverManagerConnectionPool;
import model.prodotto.ProdottoBean;

/*
 DAO per la gestione della Lista Desideri (Wishlist) e della tabella ponte 'include'.
 Consente di creare la lista per un utente, aggiungere o rimuovere articoli preferiti ed estrarre i prodotti.
*/
public class ListaDesideriDAO {

    private static final String TABLE_NAME = "lista_desideri";
    private static final String TABLE_INCLUDE = "`include`";

    /*
     Salva una nuova lista desideri nel database.
     Prende in input l'oggetto lista con il numero di prodotti e l'idUtente.
     Recupera l'ID univoco generato da MySQL e lo assegna alla lista.
    */
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

    /*
     Garantisce l'esistenza della lista desideri per un dato utente:
     se esiste gia la restituisce, altrimenti ne crea una nuova vuota e la salva nel database.
    */
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

    /*
     Recupera la lista desideri in base al suo ID univoco (id_lista_desideri).
     Restituisce l'oggetto ListaDesideriBean trovato, oppure null se non esiste.
    */
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

    /*
     Cerca e recupera la lista desideri collegata a un determinato utente tramite il suo idUtente.
     Restituisce l'oggetto ListaDesideriBean se trovato, oppure null.
    */
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

    /*
     Inserisce un prodotto tra i preferiti dell'utente (nella tabella ponte 'include').
     Prende in input l'ID della lista e l'ID del prodotto.
     Usa INSERT IGNORE per evitare duplicati e aggiorna automaticamente il conteggio totale dei prodotti.
    */
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

    /*
     Rimuove un prodotto dalla lista desideri (cancella il record dalla tabella 'include').
     Prende in input l'ID della lista e l'ID del prodotto.
     Aggiorna poi automaticamente il contatore dei prodotti nella lista.
    */
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

    /*
     Verifica se un determinato prodotto e gia presente nella lista desideri dell'utente.
     Utilizzato per decidere se mostrare l'icona del cuore piena o vuota sulla scheda prodotto.
     Restituisce true se presente, false altrimenti.
    */
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

    /*
     Svuota completamente la lista desideri eliminando tutti i prodotti dalla tabella 'include'.
     Prende in input l'ID della lista.
    */
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

    /*
     Conta quanti prodotti distinti sono salvati nella lista desideri.
     Restituisce il numero totale di prodotti.
    */
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

    /*
     Metodo interno di sincronizzazione: ricalcola il totale degli elementi salvati
     e aggiorna il campo 'prodotti' nella tabella 'lista_desideri'.
    */
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

    /*
     Esegue una JOIN tra la tabella 'prodotto' e la tabella 'include' per restituire la lista
     completa degli oggetti ProdottoBean salvati nei preferiti dell'utente.
    */
    public Collection<ProdottoBean> doRetrieveProdotti(int idLista) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        Collection<ProdottoBean> prodotti = new ArrayList<>();

        String selectSQL = "SELECT p.* FROM prodotto p " +
                           "JOIN " + TABLE_INCLUDE + " i ON p.idProdotto = i.id_prodotto " +
                           "WHERE i.id_lista = ?";
        try {
            connection = DriverManagerConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idLista);
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                ProdottoBean p = new ProdottoBean();
                p.setIdProdotto(resultSet.getInt("idProdotto"));
                p.setNome(resultSet.getString("nome"));
                p.setPrezzo(resultSet.getDouble("prezzo"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setDisponibilita(resultSet.getBoolean("disponibilita"));
                p.setSconto(resultSet.getDouble("sconto"));
                p.setIva(resultSet.getDouble("iva"));
                p.setMateriale(resultSet.getString("materiale"));
                p.setColore(resultSet.getString("colore"));
                p.setDimensione(resultSet.getString("dimensione"));
                p.setImmagine(resultSet.getString("immagine"));
                prodotti.add(p);
            }
            return prodotti;
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
     e crea un oggetto ListaDesideriBean pronto all'uso.
    */
    private ListaDesideriBean extractListaDesideri(ResultSet resultSet) throws SQLException {
        ListaDesideriBean lista = new ListaDesideriBean();

        lista.setIdListaDesideri(resultSet.getInt("id_lista_desideri"));
        lista.setProdotti(resultSet.getInt("prodotti"));
        lista.setIdUtente(resultSet.getInt("id_utente"));

        return lista;
    }
}