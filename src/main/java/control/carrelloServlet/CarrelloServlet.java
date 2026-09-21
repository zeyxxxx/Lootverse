package control.carrelloServlet;

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
import model.dto.ElementoCarrelloDTO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

/*
 Servlet per la gestione del Carrello della spesa dell'utente.
 Gestisce la visualizzazione del riepilogo carrello con calcolo subtotali (GET)
 e le operazioni di aggiunta, modifica quantita e rimozione articoli, con supporto sia standard che asincrono AJAX (POST).
 Risponde all'URL '/carrello'.
*/
@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Verifica che l'utente sia autenticato (altrimenti reindirizza a login),
     recupera o crea il carrello dell'utente dal DB, carica gli articoli contenuti (tabella contiene),
     costruisce la lista di DTO (ElementoCarrelloDTO) unendo il prodotto con la quantita e calcolando i subtotali,
     quindi inoltra il tutto alla pagina JSP 'carrello.jsp'.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

            CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());

            if (carrello == null) {
                carrello = new CarrelloBean();
                carrello.setIdUtente(utente.getIdUtente());
                carrelloDAO.doSave(carrello);

                carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
            }

            // 1. Recuperiamo gli elementi nel carrello dal DAO
            Collection<ContieneBean> elementiContenuti = carrelloDAO.doRetrieveProdotti(carrello.getIdCarrello());
            
            // 2. Creiamo la lista DTO con i dettagli completi dei prodotti per la JSP (Zero query nella JSP!)
            List<ElementoCarrelloDTO> listaDTO = new ArrayList<>();
            double totaleComplessivo = 0.0;

            if (elementiContenuti != null) {
                for (ContieneBean contiene : elementiContenuti) {
                    ProdottoBean prodotto = prodottoDao.doRetrieveById(contiene.getIdProdotto());
                    if (prodotto != null) {
                        ElementoCarrelloDTO elem = new ElementoCarrelloDTO(prodotto, contiene.getQuantita());
                        listaDTO.add(elem);
                        totaleComplessivo += elem.getSubtotale();
                    }
                }
            }

            totaleComplessivo = Math.round(totaleComplessivo * 100.0) / 100.0;

            // 3. Passiamo attributi alla richiesta
            request.setAttribute("carrello", carrello);
            request.setAttribute("elementiCarrello", listaDTO);
            request.setAttribute("totaleCarrello", totaleComplessivo);

            request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il caricamento del carrello.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    /*
     Gestisce le richieste HTTP POST per modificare il contenuto del carrello:
     - 'action=add': aggiunge un prodotto al carrello (o incrementa la quantita).
     - 'action=update': modifica la quantita (se <= 0 rimuove il prodotto).
     - 'action=remove': cancella la riga del prodotto dal carrello.
     Aggiorna il contatore 'cartBadgeCount' nella sessione.
     Se la richiesta proviene da una chiamata asincrona AJAX, risponde con un array JSON aggiornato;
     altrimenti reindirizza alla pagina del carrello.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idProdottoParam = request.getParameter("idProdotto");
        String quantitaParam = request.getParameter("quantita");

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();

            CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());

            if (carrello == null) {
                carrello = new CarrelloBean();
                carrello.setIdUtente(utente.getIdUtente());
                carrelloDAO.doSave(carrello);

                carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
            }

            if (action == null || action.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/carrello");
                return;
            }

            if ("add".equals(action)) {
                int idProdotto = Integer.parseInt(idProdottoParam);
                int quantita = 1;

                if (quantitaParam != null && !quantitaParam.trim().isEmpty()) {
                    quantita = Integer.parseInt(quantitaParam);
                }

                if (quantita < 1) {
                    quantita = 1;
                }

                carrelloDAO.aggiungiProdotto(carrello.getIdCarrello(), idProdotto, quantita);
            }

            else if ("update".equals(action)) {
                int idProdotto = Integer.parseInt(idProdottoParam);
                int quantita = Integer.parseInt(quantitaParam);

                if (quantita <= 0) {
                    carrelloDAO.rimuoviProdotto(carrello.getIdCarrello(), idProdotto);
                } else {
                    carrelloDAO.modificaQuantita(carrello.getIdCarrello(), idProdotto, quantita);
                }
            }

            else if ("remove".equals(action)) {
                int idProdotto = Integer.parseInt(idProdottoParam);

                carrelloDAO.rimuoviProdotto(carrello.getIdCarrello(), idProdotto);
            }

            int count = carrelloDAO.contaProdotti(carrello.getIdCarrello());
            session.setAttribute("cartBadgeCount", count);

            boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

            if (isAjax) {
                ProdottoDao prodottoDao = new ProdottoDao();
                Collection<ContieneBean> elementiContenuti = carrelloDAO.doRetrieveProdotti(carrello.getIdCarrello());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                java.io.PrintWriter out = response.getWriter();
                StringBuilder json = new StringBuilder("[");
                int itemCount = 0;
                if (elementiContenuti != null) {
                    for (ContieneBean contiene : elementiContenuti) {
                        ProdottoBean p = prodottoDao.doRetrieveById(contiene.getIdProdotto());
                        if (p != null) {
                            json.append("{")
                                .append("\"idProdotto\":").append(p.getIdProdotto()).append(",")
                                .append("\"nome\":\"").append(p.getNome().replace("\"", "\\\"")).append("\",")
                                .append("\"prezzo\":").append(p.getPrezzo()).append(",")
                                .append("\"prezzoIvato\":").append(p.getPrezzoIvato()).append(",")
                                .append("\"prezzoFinale\":").append(p.getPrezzoFinale()).append(",")
                                .append("\"quantita\":").append(contiene.getQuantita()).append(",")
                                .append("\"immagine\":\"").append(p.getImmagine() != null ? p.getImmagine() : "default.jpg").append("\"")
                                .append("}");
                            if (++itemCount < elementiContenuti.size()) json.append(",");
                        }
                    }
                }
                json.append("]");
                out.print(json.toString());
                out.flush();
                return;
            }

            response.sendRedirect(request.getContextPath() + "/carrello");

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Dati del carrello non validi.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante l'aggiornamento del carrello.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }
}