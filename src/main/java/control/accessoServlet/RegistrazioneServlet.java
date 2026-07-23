package control.accessoServlet;

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;
import util.PasswordUtil;

@WebServlet("/registrazione")
public class RegistrazioneServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
            "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z0-9\\s])(?=\\S+$).{8,16}$"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");

        nome = trimValue(nome);
        cognome = trimValue(cognome);
        email = trimValue(email).toLowerCase();

        try {
            if (isEmpty(nome) || isEmpty(cognome) || isEmpty(email)
                    || isEmpty(password) || isEmpty(confermaPassword)) {

                request.setAttribute("erroreCampiVuoti", "Tutti i campi sono obbligatori.");
                ripristinaCampi(request, nome, cognome, email);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            if (!EMAIL_PATTERN.matcher(email).matches()) {
                request.setAttribute("erroreEmail", "Email non valida.");
                ripristinaCampi(request, nome, cognome, email);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            if (!PASSWORD_PATTERN.matcher(password).matches()) {
                request.setAttribute("errorePassword", "La password deve avere tra 8 e 16 caratteri, almeno una lettera, un numero e un carattere speciale.");
                ripristinaCampi(request, nome, cognome, email);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confermaPassword)) {
                request.setAttribute("erroreConfermaPassword", "Le password non coincidono.");
                ripristinaCampi(request, nome, cognome, email);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            UtenteDAO utenteDAO = new UtenteDAO();

            if (utenteDAO.emailExists(email)) {
                request.setAttribute("erroreGiàPresente", "Email già registrata.");
                ripristinaCampi(request, nome, cognome, email);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            String passwordHash = PasswordUtil.toHash(password);

            UtenteBean utente = new UtenteBean();
            utente.setNome(nome);
            utente.setCognome(cognome);
            utente.setEmail(email);
            utente.setPasswordHash(passwordHash);

            utenteDAO.doSave(utente);

            request.setAttribute("successo", "Registrazione completata correttamente. Ora puoi effettuare il login.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante la registrazione. Riprova.");
            ripristinaCampi(request, nome, cognome, email);
            request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
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

    private void ripristinaCampi(HttpServletRequest request, String nome, String cognome, String email) {
        request.setAttribute("nome", nome);
        request.setAttribute("cognome", cognome);
        request.setAttribute("email", email);
    }
}
