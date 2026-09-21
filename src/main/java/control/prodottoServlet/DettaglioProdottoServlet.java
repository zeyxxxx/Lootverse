package control.prodottoServlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;

/*
 Servlet per la visualizzazione della scheda di dettaglio di un singolo prodotto.
 Carica tutti i dettagli specifici dell'articolo (descrizione estesa, dimensioni, materiale, prezzo scontato).
 Risponde all'URL '/dettaglio-prodotto'.
*/
@WebServlet("/dettaglio-prodotto")
public class DettaglioProdottoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Legge il parametro 'id' del prodotto richiesto dalla query string,
     interroga ProdottoDao.doRetrieveById() per recuperare il bean corrispondente,
     e inoltra i dati alla JSP 'dettaglioProdotto.jsp'.
     Se il prodotto non esiste, inoltra a una pagina di errore 404.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errore", "Prodotto non specificato.");
            request.getRequestDispatcher("/WEB-INF/pages/error/404.jsp").forward(request, response);
            return;
        }

        try {
            int idProdotto = Integer.parseInt(idParam);

            ProdottoDao prodottoDao = new ProdottoDao();
            ProdottoBean prodotto = prodottoDao.doRetrieveById(idProdotto);

            if (prodotto == null) {
                request.setAttribute("errore", "Prodotto non trovato.");
                request.getRequestDispatcher("/WEB-INF/pages/error/404.jsp").forward(request, response);
                return;
            }

            request.setAttribute("prodotto", prodotto);
            request.getRequestDispatcher("/WEB-INF/pages/dettaglioProdotto.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "ID prodotto non valido.");
            request.getRequestDispatcher("/WEB-INF/pages/error/404.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il caricamento del prodotto.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    /*
     Inoltra le richieste POST al metodo doGet.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}