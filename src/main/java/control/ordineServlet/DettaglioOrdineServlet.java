package control.ordineServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dettaglioOrdine.DettaglioOrdineBean;
import model.dettaglioOrdine.DettaglioOrdineDAO;
import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

/*
 Servlet per la visualizzazione dei dettagli di un singolo ordine.
 Accessibile sia dal cliente (per visualizzare il proprio acquisto) sia dall'amministratore (per il controllo ordini).
 Mostra lo stato, la data, il totale e l'elenco dei singoli articoli comprati con il prezzo storico congelato all'acquisto.
 Risponde all'URL '/dettaglio-ordine'.
*/
@WebServlet("/dettaglio-ordine")
public class DettaglioOrdineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /*
     Classe di supporto interna per unire la riga di dettaglio dell'ordine con i dati anagrafici del ProdottoBean.
    */
    public static class DettaglioItemWrapper {
        private DettaglioOrdineBean dettaglio;
        private ProdottoBean prodotto;

        public DettaglioItemWrapper(DettaglioOrdineBean dettaglio, ProdottoBean prodotto) {
            this.dettaglio = dettaglio;
            this.prodotto = prodotto;
        }

        public DettaglioOrdineBean getDettaglio() { return dettaglio; }
        public ProdottoBean getProdotto() { return prodotto; }
        public double getSubtotale() {
            return Math.round((dettaglio.getPrezzo() * dettaglio.getQuantita()) * 100.0) / 100.0;
        }
    }

    /*
     Gestisce le richieste HTTP GET.
     Verifica i permessi di accesso (utente normale o admin).
     Se l'utente e un cliente normale, controlla rigorosamente che l'ordine appartenga a lui per evitare accessi non autorizzati.
     Recupera la testata dell'ordine tramite OrdineDAO e le singole righe di dettaglio con DettaglioOrdineDAO,
     quindi inoltra il tutto alla JSP 'dettaglioOrdine.jsp'.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean isUtente = (session != null && session.getAttribute("utenteLoggato") != null);
        boolean isAdmin = (session != null && session.getAttribute("adminLoggato") != null);

        if (!isUtente && !isAdmin) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idOrdineStr = request.getParameter("id");

        if (idOrdineStr == null || idOrdineStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + (isAdmin ? "/admin-ordini" : "/storico-ordini"));
            return;
        }

        try {
            int idOrdine = Integer.parseInt(idOrdineStr);
            OrdineDAO ordineDAO = new OrdineDAO();
            OrdineBean ordine = ordineDAO.doRetrieveById(idOrdine);

            if (ordine == null) {
                response.sendRedirect(request.getContextPath() + (isAdmin ? "/admin-ordini" : "/storico-ordini"));
                return;
            }

            // Sicurezza: se è un utente normale, verifica che l'ordine sia il suo
            if (isUtente && !isAdmin) {
                UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
                if (ordine.getIdUtente() != utente.getIdUtente()) {
                    response.sendRedirect(request.getContextPath() + "/storico-ordini");
                    return;
                }
            }

            DettaglioOrdineDAO dettaglioDAO = new DettaglioOrdineDAO();
            ProdottoDao prodottoDao = new ProdottoDao();
            List<DettaglioOrdineBean> dettagli = dettaglioDAO.doRetrieveByOrdine(idOrdine);
            List<DettaglioItemWrapper> items = new ArrayList<>();

            for (DettaglioOrdineBean d : dettagli) {
                ProdottoBean p = prodottoDao.doRetrieveById(d.getIdProdotto());
                if (p != null) {
                    items.add(new DettaglioItemWrapper(d, p));
                }
            }

            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("ordine", ordine);
            request.setAttribute("dettagliItems", items);
            request.getRequestDispatcher("/WEB-INF/pages/dettaglioOrdine.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore nel caricamento dei dettagli dell'ordine.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }
}
