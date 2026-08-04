package control.listaDesideriServlet;

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

import model.listaDesideri.ListaDesideriBean;
import model.listaDesideri.ListaDesideriDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
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
            ProdottoDao prodottoDao = new ProdottoDao();

            ListaDesideriBean lista = listaDAO.creaListaPerUtente(utente.getIdUtente());

            // Nota: per recuperare i singoli ProdottoBean della wishlist possiamo
            // scorrere la lista o usare una query custom nel DAO
            List<ProdottoBean> prodottiWishlist = new ArrayList<>();
            for (ProdottoBean p : prodottoDao.doRetrieveAll()) {
                if (listaDAO.prodottoGiaPresente(lista.getIdListaDesideri(), p.getIdProdotto())) {
                    prodottiWishlist.add(p);
                }
            }

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

        if (session == null || session.getAttribute("utenteLoggato") == null) {
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

            response.sendRedirect(request.getContextPath() + "/lista-desideri");

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "ID prodotto non valido.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore nell'aggiornamento della lista desideri.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }
}