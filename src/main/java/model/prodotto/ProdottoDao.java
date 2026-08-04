package model.prodotto;

	import java.sql.Connection;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.util.Collection;
	import java.util.LinkedList;

import model.DriverManagerConnectionPool;

	public class ProdottoDao {

	    private static final String TABLE_NAME = "prodotto";

	    
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

	   
	    public synchronized void doSave(ProdottoBean prodotto) throws SQLException {
	        Connection connection = null;
	        PreparedStatement preparedStatement = null;

	        // Non inseriamo idProdotto perché è AUTO_INCREMENT nel database
	        String insertSQL = "INSERT INTO " + TABLE_NAME 
	                + " (prezzo, descrizione, disponibilita, sconto, iva, id_admin, nome, materiale, colore, dimensione) "
	                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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

	   
	    public synchronized void doUpdate(ProdottoBean prodotto) throws SQLException {
	        Connection connection = null;
	        PreparedStatement preparedStatement = null;

	        String updateSQL = "UPDATE " + TABLE_NAME + " SET "
	                + " prezzo = ?, descrizione = ?, disponibilita = ?, sconto = ?, iva = ?, "
	                + " id_admin = ?, nome = ?, materiale = ?, colore = ?, dimensione = ? "
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
	            preparedStatement.setInt(11, prodotto.getIdProdotto()); // Clausola WHERE

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

	                prodotti.add(bean);
	            }
	        } finally {
	            if (preparedStatement != null) preparedStatement.close();
	            DriverManagerConnectionPool.releaseConnection(connection);
	        }
	        return prodotti;
	    }
	}

	
	
