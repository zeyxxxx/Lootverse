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

@WebServlet("/lista-desideri")
public class ListaDesideriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
            }

            // Se la richiesta è AJAX (click dal cuore), restituiamo l'array JSON per il pannello laterale
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