package control.ordineServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Collection;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.carrello.CarrelloBean;
import model.carrello.CarrelloDAO;
import model.carrello.ContieneBean;
import model.dettaglioOrdine.DettaglioOrdineBean;
import model.dettaglioOrdine.DettaglioOrdineDAO;
import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

@WebServlet("/conferma-ordine")
public class ConfermaOrdineServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Pattern Regex per la validazione server-side di Spedizione e Pagamento Simulato
    private static final Pattern CARD_NUMBER_PATTERN = Pattern.compile("^\\d{16}$");
    private static final Pattern CVV_PATTERN = Pattern.compile("^\\d{3,4}$");
    private static final Pattern CAP_PATTERN = Pattern.compile("^\\d{5}$");
    private static final Pattern EXPIRATION_PATTERN = Pattern.compile("^(0[1-9]|1[0-2])/\\d{2}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Se un utente accede in GET, lo reindirizziamo al checkout
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

        // 1. Lettura dei parametri inviati dal form di checkout.jsp
        String indirizzo = trimValue(request.getParameter("indirizzo"));
        String citta = trimValue(request.getParameter("citta"));
        String cap = trimValue(request.getParameter("cap"));
        String intestatario = trimValue(request.getParameter("intestatario"));
        String numeroCarta = trimValue(request.getParameter("numeroCarta")).replaceAll("\\s+", "");
        String cvv = trimValue(request.getParameter("cvv"));
        String scadenza = trimValue(request.getParameter("scadenza"));

        // 2. Controlli e Validazione Server-Side
        if (isEmpty(indirizzo) || isEmpty(citta) || isEmpty(cap) || 
            isEmpty(intestatario) || isEmpty(numeroCarta) || isEmpty(cvv) || isEmpty(scadenza)) {
            
            request.setAttribute("erroreForm", "Tutti i campi di spedizione e pagamento sono obbligatori.");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        if (!CAP_PATTERN.matcher(cap).matches()) {
            request.setAttribute("erroreForm", "Il CAP inserito non è valido (deve contenere esattamente 5 cifre).");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        if (!CARD_NUMBER_PATTERN.matcher(numeroCarta).matches()) {
            request.setAttribute("erroreForm", "Il numero di carta inserito non è valido (deve essere composto da 16 cifre).");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        if (!CVV_PATTERN.matcher(cvv).matches()) {
            request.setAttribute("erroreForm", "Il codice CVV non è valido (3 o 4 cifre).");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        if (!EXPIRATION_PATTERN.matcher(scadenza).matches()) {
            request.setAttribute("erroreForm", "La data di scadenza non è valida (usa il formato MM/AA).");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        } else {
            try {
                String[] parts = scadenza.split("/");
                int expMonth = Integer.parseInt(parts[0]);
                int expYear = Integer.parseInt(parts[1]) + 2000; // Es: 25 -> 2025
                
                java.time.YearMonth currentMonth = java.time.YearMonth.now();
                java.time.YearMonth cardMonth = java.time.YearMonth.of(expYear, expMonth);
                
                if (cardMonth.isBefore(currentMonth)) {
                    request.setAttribute("erroreForm", "La carta di credito inserita risulta scaduta.");
                    request.getRequestDispatcher("/checkout").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("erroreForm", "Errore nella lettura della data di scadenza.");
                request.getRequestDispatcher("/checkout").forward(request, response);
                return;
            }
        }

        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            ProdottoDao prodottoDao = new ProdottoDao();
            OrdineDAO ordineDAO = new OrdineDAO();
            DettaglioOrdineDAO dettaglioOrdineDAO = new DettaglioOrdineDAO();

            CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());

            if (carrello == null) {
                request.setAttribute("errore", "Il carrello è vuoto.");
                request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);
                return;
            }

            Collection<ContieneBean> prodottiCarrello = carrelloDAO.doRetrieveProdotti(carrello.getIdCarrello());

            if (prodottiCarrello == null || prodottiCarrello.isEmpty()) {
                request.setAttribute("errore", "Il carrello è vuoto.");
                request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);
                return;
            }

            double totale = 0.0;

            for (ContieneBean item : prodottiCarrello) {
                ProdottoBean prodotto = prodottoDao.doRetrieveById(item.getIdProdotto());

                if (prodotto == null || !prodotto.isDisponibilita()) {
                    request.setAttribute("errore", "Uno dei prodotti nel carrello non è più disponibile.");
                    request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);
                    return;
                }

                double prezzoFinale = prodotto.getPrezzoFinale();
                totale += prezzoFinale * item.getQuantita();
            }

            // Arrotondamento a 2 cifre decimali
            totale = Math.round(totale * 100.0) / 100.0;

            // 3. Creazione e salvataggio dell'ordine
            OrdineBean ordine = new OrdineBean();
            ordine.setIdUtente(utente.getIdUtente());
            ordine.setStato("In lavorazione");
            ordine.setData(LocalDate.now());
            ordine.setTotale(totale);

            ordineDAO.doSave(ordine);

            int idOrdine = ordine.getIdOrdine();

            if (idOrdine <= 0) {
                throw new SQLException("ID ordine non generato correttamente.");
            }

            // 4. Salvataggio dei dettagli dell'ordine
            for (ContieneBean item : prodottiCarrello) {
                ProdottoBean prodotto = prodottoDao.doRetrieveById(item.getIdProdotto());

                DettaglioOrdineBean dettaglio = new DettaglioOrdineBean();
                dettaglio.setIdOrdine(idOrdine);
                dettaglio.setIdProdotto(item.getIdProdotto());
                dettaglio.setPrezzo(prodotto.getPrezzoFinale());
                dettaglio.setIva(prodotto.getIva());
                dettaglio.setQuantita(item.getQuantita());

                dettaglioOrdineDAO.doSave(dettaglio);
            }

            // 5. Svuotamento del carrello
            carrelloDAO.svuotaCarrello(carrello.getIdCarrello());
            session.setAttribute("cartBadgeCount", 0);

            request.setAttribute("ordine", ordine);
            request.getRequestDispatcher("/WEB-INF/pages/confermaOrdine.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante la conferma dell'ordine.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trimValue(String value) {
        return (value == null) ? "" : value.trim();
    }
}