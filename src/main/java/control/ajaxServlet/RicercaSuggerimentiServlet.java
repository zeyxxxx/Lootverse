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

@WebServlet("/ricerca-suggerimenti")
public class RicercaSuggerimentiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}