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

/*
 Servlet per la gestione del Login degli utenti.
 Mostra la schermata di login (GET) ed esegue l'autenticazione delle credenziali (POST).
 Se il login ha successo, crea la sessione utente e aggiorna il badge del carrello.
 Risponde all'URL '/login'.
*/
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    /*
     Gestisce le richieste HTTP GET (quando l'utente naviga sulla pagina di accesso).
     Inoltra la richiesta alla pagina JSP 'login.jsp' contenente il form di autenticazione.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    /*
     Gestisce le richieste HTTP POST (quando l'utente preme il pulsante 'Accedi' del form).
     Verifica che email e password siano inserite, calcola l'hash della password con PasswordUtil,
     interroga UtenteDAO per verificare le credenziali nel DB, crea la sessione HTTP salvandovi l'utente
     e reindirizza al catalogo dei prodotti.
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