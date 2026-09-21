package control.ajaxServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;

/*
 Servlet AJAX per la barra di ricerca live dei prodotti (autocomplete).
 Riceve la stringa digitata dall'utente e restituisce in tempo reale un array JSON
 contenente i prodotti corrispondenti (ID, nome e prezzo finale calcolato).
 Risponde all'URL '/ricerca-suggerimenti'.
*/
@WebServlet("/ricerca-suggerimenti")
public class RicercaSuggerimentiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Legge la stringa di ricerca 'q'. Se contiene almeno 2 caratteri, interroga ProdottoDao.doSearchByName(),
     costruisce a mano una stringa in formato JSON con i risultati e la invia al browser.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        PrintWriter out = response.getWriter();

        if (query == null || query.trim().length() < 2) {
            out.print("[]");
            out.flush();
            return;
        }

        try {
            ProdottoDao prodottoDao = new ProdottoDao();
            Collection<ProdottoBean> risultati = prodottoDao.doSearchByName(query);

            StringBuilder json = new StringBuilder("[");
            int i = 0;
            for (ProdottoBean p : risultati) {
                if (i > 0) json.append(",");
                
                // Escape basico per virgolette
                String nomePulito = p.getNome().replace("\"", "\\\"");
                
                json.append("{")
                    .append("\"id\":").append(p.getIdProdotto()).append(",")
                    .append("\"nome\":\"").append(nomePulito).append("\",")
                    .append("\"prezzo\":").append(p.getPrezzoFinale())
                    .append("}");
                i++;
            }
            json.append("]");

            out.print(json.toString());

        } catch (SQLException e) {
            e.printStackTrace();
            out.print("[]");
        }
        
        out.flush();
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