package control.adminServlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 Servlet per la disconnessione (logout) dell'amministratore.
 Rimuove l'attributo di sessione dell'admin e reindirizza alla schermata di login admin.
 Risponde all'URL '/admin-logout'.
*/
@WebServlet("/admin-logout")
public class AdminLogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Rimuove l'amministratore dalla sessione corrente e reindirizza a '/admin-login'.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.removeAttribute("adminLoggato");
            if (session.getAttribute("utenteLoggato") == null) {
                session.invalidate();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin-login");
    }

    /*
     Gestisce le richieste HTTP POST rimandandole al metodo doGet per eseguire il logout.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}