package control.ajaxServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.utente.UtenteDAO;

/*
 Servlet AJAX per la verifica asincrona della disponibilita di un indirizzo email.
 Viene richiamata da JavaScript durante la digitazione nel form di registrazione.
 Risponde con un payload JSON del tipo: {"exists": true/false}.
 Risponde all'URL '/check-email'.
*/
@WebServlet("/check-email")
public class CheckEmailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Legge il parametro 'email' dalla richiesta, interroga UtenteDAO.emailExists()
     e scrive direttamente nello stream di risposta un oggetto JSON con il risultato booleano.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        boolean giaPresente = false;

        if (email != null && !email.trim().isEmpty()) {
            try {
                UtenteDAO utenteDAO = new UtenteDAO();
                giaPresente = utenteDAO.emailExists(email.trim().toLowerCase());
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Output JSON senza librerie esterne
        PrintWriter out = response.getWriter();
        out.print("{\"exists\": " + giaPresente + "}");
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