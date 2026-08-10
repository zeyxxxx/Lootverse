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

@WebServlet("/dettaglio-ordine")
public class DettaglioOrdineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
        String idOrdineStr = request.getParameter("id");

        if (idOrdineStr == null || idOrdineStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/storico-ordini");
            return;
        }

        try {
            int idOrdine = Integer.parseInt(idOrdineStr);
            OrdineDAO ordineDAO = new OrdineDAO();
            OrdineBean ordine = null;

            // Controlla che l'ordine appartenga all'utente loggato (Sicurezza)
            for (OrdineBean ob : ordineDAO.doRetrieveByUtente(utente.getIdUtente())) {
                if (ob.getIdOrdine() == idOrdine) {
                    ordine = ob;
                    break;
                }
            }

            if (ordine == null) {
                // Ordine non trovato o tentativo di accesso non autorizzato
                response.sendRedirect(request.getContextPath() + "/storico-ordini");
                return;
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
