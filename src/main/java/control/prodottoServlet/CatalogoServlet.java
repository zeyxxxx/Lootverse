package control.prodottoServlet;

import java.io.IOException;
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
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdottoDao prodottoDao = new ProdottoDao();

        try {
            Collection<ProdottoBean> prodotti = prodottoDao.doRetrieveAll();
            request.setAttribute("prodotti", prodotti);

            // Recupero della Wishlist se l'utente è loggato
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("utenteLoggato") != null) {
                UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
                ListaDesideriDAO listaDAO = new ListaDesideriDAO();
                ListaDesideriBean lista = listaDAO.doRetrieveByUtente(utente.getIdUtente());
                if (lista != null) {
                    Collection<ProdottoBean> prodottiWishlist = listaDAO.doRetrieveProdotti(lista.getIdListaDesideri());
                    request.setAttribute("prodottiWishlist", prodottiWishlist);
                }
            }

            request.getRequestDispatcher("/WEB-INF/pages/catalogo.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il caricamento del catalogo.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}