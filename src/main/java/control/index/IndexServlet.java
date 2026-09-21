package control.index;

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

import model.listaDesideri.ListaDesideriBean;
import model.listaDesideri.ListaDesideriDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

/*
 Servlet principale per la Homepage del sito.
 Carica i prodotti in evidenza per il carosello superiore, i bestseller piu venduti,
 gli articoli in offerta speciale scontati e la wishlist dell'utente (se loggato).
 Risponde sia alla radice dell'applicazione '' che all'URL '/index'.
*/
@WebServlet(urlPatterns = { "", "/index" })
public class IndexServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProdottoDao prodottoDao = new ProdottoDao();

    /*
     Gestisce le richieste HTTP GET.
     Interroga ProdottoDao per prelevare:
     - 3 articoli per il carosello principale
     - gli 8 prodotti piu venduti tramite la classifica reale doRetrieveBestSellers(8)
     - fino a 8 prodotti con sconto attivo per le offerte speciali
     Se l'utente e loggato, recupera anche i suoi articoli preferiti dalla wishlist.
     Infine inoltra tutti i dati alla JSP 'index.jsp'.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Chiamata al metodo doRetrieveAll() del tuo DAO
            Collection<ProdottoBean> prodottiCollection = prodottoDao.doRetrieveAll();

            // Conversione da Collection a List per la gestione delle sotto-liste
            List<ProdottoBean> tuttiProdotti = new ArrayList<>(prodottiCollection);

            if (!tuttiProdotti.isEmpty()) {
                // Primi 3 prodotti per il carosello
                int limiteCarosello = Math.min(tuttiProdotti.size(), 3);
                request.setAttribute("prodottiCarosello", tuttiProdotti.subList(0, limiteCarosello));

                // Fino a 8 prodotti per la sezione "I Più Venduti" (Classifica reale dal DB)
                Collection<ProdottoBean> bestSellers = prodottoDao.doRetrieveBestSellers(8);
                request.setAttribute("prodottiPiuVenduti", bestSellers);

                // Prodotti Scontati (Offerte Speciali) - Fino a 8 prodotti
                List<ProdottoBean> prodottiScontati = new ArrayList<>();
                for (ProdottoBean p : tuttiProdotti) {
                    if (p.isDisponibilita() && p.getSconto() > 0) {
                        prodottiScontati.add(p);
                        if (prodottiScontati.size() >= 8)
                            break;
                    }
                }
                request.setAttribute("prodottiScontati", prodottiScontati);
            }

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

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Inoltro alla pagina index.jsp
        request.getRequestDispatcher("/WEB-INF/pages/index.jsp").forward(request, response);
    }

    /*
     Inoltra le richieste POST al metodo doGet per mostrare la homepage.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}