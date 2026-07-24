package control.carrelloServlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.carrello.CarrelloBean;
import model.carrello.CarrelloDAO;
import model.utente.UtenteBean;

@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();

            CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());

            if (carrello == null) {
                carrello = new CarrelloBean();
                carrello.setIdUtente(utente.getIdUtente());
                carrelloDAO.doSave(carrello);

                carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
            }

            request.setAttribute("carrello", carrello);
            request.getRequestDispatcher("/WEB-INF/pages/carrello.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il caricamento del carrello.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utenteLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idProdottoParam = request.getParameter("idProdotto");
        String quantitaParam = request.getParameter("quantita");

        UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");

        try {
            CarrelloDAO carrelloDAO = new CarrelloDAO();

            CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());

            if (carrello == null) {
                carrello = new CarrelloBean();
                carrello.setIdUtente(utente.getIdUtente());
                carrelloDAO.doSave(carrello);

                carrello = carrelloDAO.doRetrieveByUtente(utente.getIdUtente());
            }

            if (action == null || action.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/carrello");
                return;
            }

            if ("add".equals(action)) {
                int idProdotto = Integer.parseInt(idProdottoParam);
                int quantita = 1;

                if (quantitaParam != null && !quantitaParam.trim().isEmpty()) {
                    quantita = Integer.parseInt(quantitaParam);
                }

                if (quantita < 1) {
                    quantita = 1;
                }

                carrelloDAO.aggiungiProdotto(carrello.getIdCarrello(), idProdotto, quantita);
            }

            else if ("update".equals(action)) {
                int idProdotto = Integer.parseInt(idProdottoParam);
                int quantita = Integer.parseInt(quantitaParam);

                if (quantita <= 0) {
                    carrelloDAO.rimuoviProdotto(carrello.getIdCarrello(), idProdotto);
                } else {
                    carrelloDAO.modificaQuantita(carrello.getIdCarrello(), idProdotto, quantita);
                }
            }

            else if ("remove".equals(action)) {
                int idProdotto = Integer.parseInt(idProdottoParam);

                carrelloDAO.rimuoviProdotto(carrello.getIdCarrello(), idProdotto);
            }

            response.sendRedirect(request.getContextPath() + "/carrello");

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Dati del carrello non validi.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante l'aggiornamento del carrello.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }
}