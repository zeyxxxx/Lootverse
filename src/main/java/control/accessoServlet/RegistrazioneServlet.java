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

/*
 Servlet per la gestione della registrazione dei nuovi utenti.
 Gestisce la visualizzazione della pagina con il form (GET)
 e la ricezione, validazione e salvataggio del nuovo profilo (POST).
 Risponde all'URL '/registrazione'.
*/
@WebServlet("/registrazione")
public class RegistrazioneServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
            "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z0-9\\s])(?=\\S+$).{8,16}$"
    );

    // Pattern per il numero completo (es. +393123456789)
    private static final Pattern TELEFONO_PATTERN = Pattern.compile(
            "^\\+[0-9]{9,16}$"
    );

    /*
     Gestisce le richieste HTTP GET (quando l'utente visita la pagina digitando l'URL o cliccando su 'Registrati').
     Inoltra la richiesta alla pagina JSP 'registrazione.jsp' che mostra a video il modulo vuoto.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
    }

    /*
     Gestisce le richieste HTTP POST (quando l'utente clicca sul pulsante 'Registrati' del form).
     Estrae i dati inviati, valida tutti i campi (presenza, formato email, telefono e criteri password),
     controlla che l'email non sia gia presente nel DB, cifra la password con SHA-512 tramite PasswordUtil,
     salva il nuovo utente con UtenteDAO e infine reindirizza alla pagina di login.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String prefisso = request.getParameter("prefisso"); // Recupero prefisso
        String telefono = request.getParameter("telefono"); // Recupero numero
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");

        nome = trimValue(nome);
        cognome = trimValue(cognome);
        email = trimValue(email).toLowerCase();
        prefisso = trimValue(prefisso);
        telefono = trimValue(telefono);

        // Se il prefisso non e selezionato, imposta default +39
        if (isEmpty(prefisso)) {
            prefisso = "+39";
        }

        // Unisce prefisso e numero (es. +393123456789)
        String telefonoCompleto = prefisso + telefono;

        try {
            if (isEmpty(nome) || isEmpty(cognome) || isEmpty(email)
                    || isEmpty(telefono) || isEmpty(password) || isEmpty(confermaPassword)) {

                request.setAttribute("erroreCampiVuoti", "Tutti i campi sono obbligatori.");
                ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            if (!EMAIL_PATTERN.matcher(email).matches()) {
                request.setAttribute("erroreEmail", "Email non valida.");
                ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            // Validazione del numero telefonico completo con prefisso
            if (!TELEFONO_PATTERN.matcher(telefonoCompleto).matches()) {
                request.setAttribute("erroreTelefono", "Numero di telefono non valido (inserisci solo cifre).");
                ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            if (!PASSWORD_PATTERN.matcher(password).matches()) {
                request.setAttribute("errorePassword", "La password deve avere tra 8 e 16 caratteri, almeno una lettera, un numero e un carattere speciale.");
                ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confermaPassword)) {
                request.setAttribute("erroreConfermaPassword", "Le password non coincidono.");
                ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            UtenteDAO utenteDAO = new UtenteDAO();

            if (utenteDAO.emailExists(email)) {
                request.setAttribute("erroreGiàPresente", "Email già registrata.");
                ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
                request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
                return;
            }

            String passwordHash = PasswordUtil.toHash(password);

            UtenteBean utente = new UtenteBean();
            utente.setNome(nome);
            utente.setCognome(cognome);
            utente.setEmail(email);
            utente.setTelefono(telefonoCompleto); // Salva il numero completo (es. +393123456789)
            utente.setPasswordHash(passwordHash);

            utenteDAO.doSave(utente);

            request.setAttribute("successo", "Registrazione completata correttamente. Ora puoi effettuare il login.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante la registrazione. Riprova.");
            ripristinaCampi(request, nome, cognome, email, prefisso, telefono);
            request.getRequestDispatcher("/WEB-INF/pages/registrazione.jsp").forward(request, response);
        }
    }

    /*
     Metodo di supporto: controlla se una stringa e null oppure vuota (composta solo da spazi).
     Restituisce true se la stringa non contiene caratteri utili, false altrimenti.
    */
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /*
     Metodo di supporto: elimina gli spazi superflui all'inizio e alla fine del testo digitato dall'utente.
     Se il valore e null restituisce una stringa vuota per evitare errori a runtime.
    */
    private String trimValue(String value) {
        if (value == null) {
            return "";
        }
        return value.trim();
    }

    /*
     Metodo di supporto: in caso di errore nei controlli, salva nuovamente i dati inseriti dall'utente
     negli attributi della richiesta (request), cosi che la pagina JSP possa ripopolare i campi del form
     evitando all'utente di dover riscrivere tutto da capo.
    */
    private void ripristinaCampi(HttpServletRequest request, String nome, String cognome, String email, String prefisso, String telefono) {
        request.setAttribute("nome", nome);
        request.setAttribute("cognome", cognome);
        request.setAttribute("email", email);
        request.setAttribute("prefisso", prefisso);
        request.setAttribute("telefono", telefono);
    }
}