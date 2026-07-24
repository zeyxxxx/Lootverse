package control.ordineServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

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

import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/conferma-ordine")
public class ConfermaOrdineServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/carrello");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

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

            BigDecimal totale = BigDecimal.ZERO;

            for (ContieneBean item : prodottiCarrello) {
                ProdottoBean prodotto = prodottoDao.doRetrieveById(item.getIdProdotto());

                if (prodotto == null || !prodotto.isDisponibilita()) {
                    request.setAttribute("errore", "Uno dei prodotti nel carrello non è più disponibile.");
                    request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);
                    return;
                }

                BigDecimal prezzoFinale = BigDecimal.valueOf(prodotto.getPrezzoFinale());
                BigDecimal quantita = BigDecimal.valueOf(item.getQuantita());

                totale = totale.add(prezzoFinale.multiply(quantita));
            }

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

            for (ContieneBean item : prodottiCarrello) {
                ProdottoBean prodotto = prodottoDao.doRetrieveById(item.getIdProdotto());

                DettaglioOrdineBean dettaglio = new DettaglioOrdineBean();
                dettaglio.setIdOrdine(idOrdine);
                dettaglio.setIdProdotto(item.getIdProdotto());
                dettaglio.setPrezzo(BigDecimal.valueOf(prodotto.getPrezzoFinale()));
                dettaglio.setIva(BigDecimal.valueOf(prodotto.getIva()));
                dettaglio.setQuantita(item.getQuantita());

                dettaglioOrdineDAO.doSave(dettaglio);
            }

            carrelloDAO.svuotaCarrello(carrello.getIdCarrello());

            request.setAttribute("ordine", ordine);
            request.getRequestDispatcher("/WEB-INF/pages/confermaOrdine.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante la conferma dell'ordine.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }
}
