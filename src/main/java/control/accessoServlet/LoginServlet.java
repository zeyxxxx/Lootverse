package control.accessoServlet;

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;
import util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

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
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
                return;
            }

            if (!EMAIL_PATTERN.matcher(email).matches()) {
                request.setAttribute("erroreLogin", "Formato email non valido.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
                return;
            }

            String passwordHash = PasswordUtil.toHash(password);

            UtenteDAO utenteDAO = new UtenteDAO();
            UtenteBean utente = utenteDAO.doLogin(email, passwordHash);

            if (utente == null) {
                request.setAttribute("erroreLogin", "Email o password non corretti.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("utenteLoggato", utente);
            session.setMaxInactiveInterval(30 * 60);
            
            try {
                model.carrello.CarrelloDAO carrelloDAO = new model.carrello.CarrelloDAO();
                model.carrello.CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
                if(carrello != null) {
                    session.setAttribute("cartBadgeCount", carrelloDAO.contaProdotti(carrello.getIdCarrello()));
                } else {
                    session.setAttribute("cartBadgeCount", 0);
                }
            } catch (Exception ignored) {
            }

            response.sendRedirect(request.getContextPath() + "/catalogo");

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("erroreLogin", "Errore durante il login. Riprova.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trimValue(String value) {
        if (value == null) {
            return "";
        }

        return value.trim();
    }
}