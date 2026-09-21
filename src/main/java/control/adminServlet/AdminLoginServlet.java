package control.adminServlet;

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.admin.AdminBean;
import model.admin.AdminDAO;
import util.PasswordUtil;

/*
 Servlet per la gestione del Login dell'amministratore.
 Mostra la schermata di login per lo staff (GET) ed autentica le credenziali admin (POST).
 Risponde all'URL '/admin-login'.
*/
@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    /*
     Gestisce le richieste HTTP GET.
     Inoltra alla pagina JSP 'adminLogin.jsp' contenente il form di autenticazione per l'amministratore.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/pages/admin/adminLogin.jsp").forward(request, response);
    }

    /*
     Gestisce le richieste HTTP POST quando viene inviato il form di accesso admin.
     Verifica i campi, cifra la password con SHA-512, interroga AdminDAO per verificare
     le credenziali nella tabella 'admin', salva l'oggetto AdminBean nella sessione e reindirizza al pannello prodotti.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        email = trimValue(email).toLowerCase();

        try {
            if (isEmpty(email) || isEmpty(password)) {
                request.setAttribute("erroreLogin", "Email e password sono obbligatorie.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminLogin.jsp").forward(request, response);
                return;
            }

            if (!EMAIL_PATTERN.matcher(email).matches()) {
                request.setAttribute("erroreLogin", "Formato email non valido.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminLogin.jsp").forward(request, response);
                return;
            }

            String passwordHash = PasswordUtil.toHash(password);

            AdminDAO adminDAO = new AdminDAO();
            AdminBean admin = adminDAO.doLogin(email, passwordHash);

            if (admin == null) {
                request.setAttribute("erroreLogin", "Credenziali admin non corrette.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/pages/admin/adminLogin.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("adminLoggato", admin);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/admin-prodotti");

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("erroreLogin", "Errore durante il login admin. Riprova.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/admin/adminLogin.jsp").forward(request, response);
        }
    }

    /*
     Metodo di supporto: controlla se una stringa e null o vuota.
    */
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /*
     Metodo di supporto: rimuove gli spazi iniziali e finali o restituisce una stringa vuota se null.
    */
    private String trimValue(String value) {
        if (value == null) {
            return "";
        }

        return value.trim();
    }
}