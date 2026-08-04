package control.adminServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;

@WebServlet("/admin-ordini")
public class AdminOrdiniServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        OrdineDAO ordineDAO = new OrdineDAO();

        String idUtenteParam = request.getParameter("idUtente");
        String dataInizioParam = request.getParameter("dataInizio");
        String dataFineParam = request.getParameter("dataFine");

        try {
            Collection<OrdineBean> ordini;

            
            if (idUtenteParam != null && !idUtenteParam.trim().isEmpty()) {
                int idUtente = Integer.parseInt(idUtenteParam);
                ordini = ordineDAO.doRetrieveByUtente(idUtente);
                request.setAttribute("filtroApplicato", "Utente ID: " + idUtente);

          
            } else if (dataInizioParam != null && !dataInizioParam.trim().isEmpty()
                    && dataFineParam != null && !dataFineParam.trim().isEmpty()) {
                
                LocalDate dataInizio = LocalDate.parse(dataInizioParam);
                LocalDate dataFine = LocalDate.parse(dataFineParam);
                
                ordini = ordineDAO.doRetrieveByDate(dataInizio, dataFine);
                request.setAttribute("filtroApplicato", "Dal " + dataInizio + " al " + dataFine);

           
            } else {
                ordini = ordineDAO.doRetrieveAll();
            }

            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("/WEB-INF/pages/admin/gestioneOrdini.jsp").forward(request, response);

        } catch (NumberFormatException | DateTimeParseException e) {
            request.setAttribute("errore", "Parametri di filtro non validi.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore durante il recupero degli ordini.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        String idOrdineParam = request.getParameter("idOrdine");
        String nuovoStato = request.getParameter("nuovoStato");

        if ("updateStato".equals(action)) {
            try {
                int idOrdine = Integer.parseInt(idOrdineParam);
                
                OrdineDAO ordineDAO = new OrdineDAO();
                ordineDAO.updateStato(idOrdine, nuovoStato);

                session.setAttribute("messaggioSuccesso", "Stato dell'ordine #" + idOrdine + " aggiornato in: " + nuovoStato);
                response.sendRedirect(request.getContextPath() + "/admin-ordini");

            } catch (IllegalArgumentException e) {
                request.setAttribute("errore", "Stato o ID ordine non valido.");
                request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errore", "Errore durante l'aggiornamento dello stato dell'ordine.");
                request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-ordini");
        }
    }
}
