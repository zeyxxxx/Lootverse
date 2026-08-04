package control.ordineServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.carrello.CarrelloBean;
import model.carrello.CarrelloDAO;
import model.carrello.ContieneBean;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

/**
 * Servlet per la preparazione e visualizzazione della pagina di Checkout.
 * Recupera i prodotti dal carrello dell'utente, ne verifica la disponibilità,
 * calcola i subtotali e invia i dati alla JSP del checkout.
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Helper interno per incapsulare il Prodotto, la relativa quantità e il subtotale.
     * Facilita l'iterazione e il rendering dei dati all'interno della JSP.
     */
    public static class CartItemWrapper {
        private ProdottoBean prodotto;
        private int quantita;

        public CartItemWrapper(ProdottoBean prodotto, int quantita) {
            this.prodotto = prodotto;
            this.quantita = quantita;
        }

        public ProdottoBean getProdotto() { 
            return prodotto; 
        }
        
        public int getQuantita() { 
            return quantita; 
        }
        
        public double getSubtotale() { 
            return Math.round((prodotto.getPrezzoFinale() * quantita) * 100.0) / 100.0; 
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Controllo di sicurezza e autenticazione utente
        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            ProdottoDao prodottoDao = new ProdottoDao();

            // 2. Recupero del carrello associato all'utente
            CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());

            if (carrello == null) {
                response.sendRedirect(request.getContextPath() + "/carrello");
                return;
            }

            Collection<ContieneBean> elementiCarrello = carrelloDAO.doRetrieveProdotti(carrello.getIdCarrello());

            // 3. Gestione carrello vuoto
            if (elementiCarrello == null || elementiCarrello.isEmpty()) {
                request.setAttribute("errore", "Il carrello è vuoto. Aggiungi prodotti prima di procedere al checkout.");
                request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);
                return;
            }

            List<CartItemWrapper> items = new ArrayList<>();
            double totaleComplessivo = 0.0;

            // 4. Arricchimento dati prodotti e verifica disponibilità
            for (ContieneBean contiene : elementiCarrello) {
                ProdottoBean prodotto = prodottoDao.doRetrieveById(contiene.getIdProdotto());

                if (prodotto != null && prodotto.isDisponibilita()) {
                    CartItemWrapper wrapper = new CartItemWrapper(prodotto, contiene.getQuantita());
                    items.add(wrapper);
                    totaleComplessivo += wrapper.getSubtotale();
                }
            }

            // Fallback se nessun prodotto a carrello risulta più disponibile
            if (items.isEmpty()) {
                request.setAttribute("errore", "Nessun prodotto nel carrello risulta al momento disponibile.");
                request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);
                return;
            }

            // 5. Arrotondamento a 2 cifre decimali del totale generale
            totaleComplessivo = Math.round(totaleComplessivo * 100.0) / 100.0;

            // 6. Impostazione degli attributi per la JSP e Forward
            request.setAttribute("carrelloItems", items);
            request.setAttribute("totaleOrdine", totaleComplessivo);

            request.getRequestDispatcher("/WEB-INF/pages/checkout.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore durante il caricamento della pagina di checkout.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}