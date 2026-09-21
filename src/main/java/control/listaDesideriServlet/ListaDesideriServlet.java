package control.listaDesideriServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.listaDesideri.ListaDesideriBean;
import model.listaDesideri.ListaDesideriDAO;
import model.prodotto.ProdottoBean;
import model.utente.UtenteBean;

/*
 Servlet per la gestione della Lista Desideri (Wishlist) dell'utente.
 Gestisce la visualizzazione della pagina dei preferiti (GET)
 e le operazioni di aggiunta, rimozione, svuotamento e spostamento di tutti gli articoli nel carrello (POST),
 con pieno supporto sia a navigazione tradizionale che a chiamate asincrone AJAX.
 Risponde all'URL '/lista-desideri'.
*/
@WebServlet("/lista-desideri")
public class ListaDesideriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Verifica l'autenticazione dell'utente, recupera o crea la lista desideri con ListaDesideriDAO,
     estrae la collezione dei prodotti preferiti (ProdottoBean) e inoltra alla JSP 'listaDesideri.jsp'.
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
            ListaDesideriDAO listaDAO = new ListaDesideriDAO();
            ListaDesideriBean lista = listaDAO.creaListaPerUtente(utente.getIdUtente());

            // Recupero diretto e ottimizzato tramite il metodo dedicato del DAO
            Collection<ProdottoBean> prodottiWishlist = listaDAO.doRetrieveProdotti(lista.getIdListaDesideri());

            request.setAttribute("listaDesideri", lista);
            request.setAttribute("prodottiWishlist", prodottiWishlist);

            request.getRequestDispatcher("/WEB-INF/pages/listaDesideri.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore durante il recupero della lista desideri.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    /*
     Gestisce le richieste HTTP POST per modificare la lista desideri:
     - 'action=add': aggiunge un prodotto alla lista (tabella include).
     - 'action=remove': toglie un prodotto dalla lista.
     - 'action=clear': svuota interamente la lista desideri.
     - 'action=addAllToCart': aggiunge tutti i prodotti presenti nella lista desideri al carrello dell'utente.
     Se la richiesta e AJAX (es. click sull'icona a forma di cuore), risponde con un array JSON contenente la lista aggiornata;
     altrimenti effettua il redirect alla pagina della lista desideri.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"login_required\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
        String action = request.getParameter("action");
        String idProdottoParam = request.getParameter("idProdotto");

        try {
            ListaDesideriDAO listaDAO = new ListaDesideriDAO();
            ListaDesideriBean lista = listaDAO.creaListaPerUtente(utente.getIdUtente());

            if ("add".equals(action) && idProdottoParam != null) {
                int idProdotto = Integer.parseInt(idProdottoParam);
                listaDAO.aggiungiProdotto(lista.getIdListaDesideri(), idProdotto);

            } else if ("remove".equals(action) && idProdottoParam != null) {
                int idProdotto = Integer.parseInt(idProdottoParam);
                listaDAO.rimuoviProdotto(lista.getIdListaDesideri(), idProdotto);

            } else if ("clear".equals(action)) {
                listaDAO.svuotaLista(lista.getIdListaDesideri());

            } else if ("addAllToCart".equals(action)) {
                Collection<ProdottoBean> prodotti = listaDAO.doRetrieveProdotti(lista.getIdListaDesideri());
                if (prodotti != null && !prodotti.isEmpty()) {
                    model.carrello.CarrelloDAO carrelloDAO = new model.carrello.CarrelloDAO();
                    model.carrello.CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
                    if (carrello == null) {
                        carrello = new model.carrello.CarrelloBean();
                        carrello.setIdUtente(utente.getIdUtente());
                        carrelloDAO.doSave(carrello);
                        carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
                    }
                    for (ProdottoBean p : prodotti) {
                        carrelloDAO.aggiungiProdotto(carrello.getIdCarrello(), p.getIdProdotto(), 1);
                    }
                    int count = carrelloDAO.contaProdotti(carrello.getIdCarrello());
                    session.setAttribute("cartBadgeCount", count);
                }
            }

            // Se la richiesta e AJAX (click dal cuore), restituiamo l'array JSON per il pannello laterale
            if (isAjax) {
                Collection<ProdottoBean> prodotti = listaDAO.doRetrieveProdotti(lista.getIdListaDesideri());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();

                StringBuilder json = new StringBuilder("[");
                int count = 0;
                for (ProdottoBean p : prodotti) {
                    json.append("{")
                        .append("\"idProdotto\":").append(p.getIdProdotto()).append(",")
                        .append("\"nome\":\"").append(p.getNome().replace("\"", "\\\"")).append("\",")
                        .append("\"prezzo\":").append(p.getPrezzo()).append(",")
                        .append("\"prezzoIvato\":").append(p.getPrezzoIvato()).append(",")
                        .append("\"prezzoFinale\":").append(p.getPrezzoFinale()).append(",")
                        .append("\"immagine\":\"").append(p.getImmagine() != null ? p.getImmagine() : "default.jpg").append("\"")
                        .append("}");
                    if (++count < prodotti.size()) json.append(",");
                }
                json.append("]");
                out.print(json.toString());
                out.flush();
                return;
            }

            // Richiesta standard (es. pulizia lista o submit classico): redirect alla pagina completa
            response.sendRedirect(request.getContextPath() + "/lista-desideri");

        } catch (NumberFormatException e) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            request.setAttribute("errore", "ID prodotto non valido.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
            request.setAttribute("errore", "Errore nell'aggiornamento della lista desideri.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }
}