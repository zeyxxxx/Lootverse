package control.accessoServlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 Servlet per la disconnessione (logout) dell'utente.
 Distrugge la sessione HTTP corrente e reindirizza l'utente alla schermata di login.
 Risponde all'URL '/logout'.
*/
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Recupera la sessione attiva dell'utente e, se esiste, la invalida (cancellando i dati di login),
     quindi reindirizza il browser alla pagina di login.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/login");
    }

    /*
     Gestisce le richieste HTTP POST inoltrandole al metodo doGet per eseguire la disconnessione.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}