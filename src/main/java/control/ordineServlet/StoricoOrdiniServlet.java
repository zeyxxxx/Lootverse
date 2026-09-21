package control.ordineServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;
import model.utente.UtenteBean;

/*
 Servlet per la visualizzazione dello storico ordini del cliente.
 Mostra al cliente la cronologia di tutti gli acquisti effettuati, ordinati per data decrescente.
 Risponde all'URL '/storico-ordini'.
*/
@WebServlet("/storico-ordini")
public class StoricoOrdiniServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Verifica l'autenticazione dell'utente, interroga OrdineDAO.doRetrieveByUtente()
     per estrarre tutti gli ordini del cliente loggato e inoltra la collezione alla JSP 'storicoOrdine.jsp'.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

        OrdineDAO ordineDAO = new OrdineDAO();

        try {
            Collection<OrdineBean> ordini = ordineDAO.doRetrieveByUtente(utente.getIdUtente());

            request.setAttribute("ordini", ordini);

            request.getRequestDispatcher("/WEB-INF/pages/storicoOrdine.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il recupero dello storico degli ordini.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
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