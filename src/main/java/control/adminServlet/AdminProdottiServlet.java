package control.adminServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.admin.AdminBean;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;

@WebServlet("/admin-prodotti")
public class AdminProdottiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminLoggato") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        ProdottoDao prodottoDao = new ProdottoDao();

        try {
            // Se richiesta la modifica di un singolo prodotto, recuperiamo i dati per precompilare il form
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    int idProdotto = Integer.parseInt(idParam);
                    ProdottoBean prodottoEdit = prodottoDao.doRetrieveById(idProdotto);
                    request.setAttribute("prodottoEdit", prodottoEdit);
                }
            }

            Collection<ProdottoBean> prodotti = prodottoDao.doRetrieveAll();
            request.setAttribute("prodotti", prodotti);

            request.getRequestDispatcher("/WEB-INF/pages/admin/gestioneProdotti.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "ID prodotto non valido.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore nel caricamento del catalogo prodotti per l'amministrazione.");
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

        AdminBean admin = (AdminBean) session.getAttribute("adminLoggato");
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-prodotti");
            return;
        }

        ProdottoDao prodottoDao = new ProdottoDao();

        try {
            if ("add".equals(action)) {
                ProdottoBean nuovoProdotto = estraiProdottoDaForm(request);
                nuovoProdotto.setId_admin(admin.getIdAdmin());

                prodottoDao.doSave(nuovoProdotto);
                session.setAttribute("messaggioSuccesso", "Prodotto inserito con successo.");

            } else if ("update".equals(action)) {
                int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
                
                ProdottoBean prodottoModificato = estraiProdottoDaForm(request);
                prodottoModificato.setIdProdotto(idProdotto);
                prodottoModificato.setId_admin(admin.getIdAdmin());

                prodottoDao.doUpdate(prodottoModificato);
                session.setAttribute("messaggioSuccesso", "Prodotto aggiornato con successo.");

            } else if ("delete".equals(action)) {
                int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
                
                prodottoDao.doDelete(idProdotto);
                session.setAttribute("messaggioSuccesso", "Prodotto eliminato con successo.");
            }

            response.sendRedirect(request.getContextPath() + "/admin-prodotti");

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Formato dati inseriti non valido.");
            request.getRequestDispatcher("/WEB-INF/pages/error/400.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore durante l'operazione sui prodotti.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    private ProdottoBean estraiProdottoDaForm(HttpServletRequest request) {
        ProdottoBean p = new ProdottoBean();

        p.setNome(trimValue(request.getParameter("nome")));
        p.setDescrizione(trimValue(request.getParameter("descrizione")));
        p.setMateriale(trimValue(request.getParameter("materiale")));
        p.setColore(trimValue(request.getParameter("colore")));
        p.setDimensione(trimValue(request.getParameter("dimensione")));

        String prezzoParam = request.getParameter("prezzo");
        p.setPrezzo(prezzoParam != null && !prezzoParam.trim().isEmpty() ? Double.parseDouble(prezzoParam) : 0.0);

        String scontoParam = request.getParameter("sconto");
        p.setSconto(scontoParam != null && !scontoParam.trim().isEmpty() ? Double.parseDouble(scontoParam) : 0.0);

        String ivaParam = request.getParameter("iva");
        p.setIva(ivaParam != null && !ivaParam.trim().isEmpty() ? Double.parseDouble(ivaParam) : 22.0);

        String dispParam = request.getParameter("disponibilita");
        p.setDisponibilita("true".equalsIgnoreCase(dispParam) || "1".equals(dispParam) || "on".equalsIgnoreCase(dispParam));
        
        String imm = trimValue(request.getParameter("immagine"));
        p.setImmagine(imm.isEmpty() ? "default.jpg" : imm);
        
        p.setImmagineCarosello(trimValue(request.getParameter("immagine_carosello")));
        p.setTipoArma(trimValue(request.getParameter("tipo_arma")));
        p.setTipoMedia(trimValue(request.getParameter("tipo_media")));
        p.setMondoProvenienza(trimValue(request.getParameter("mondo_provenienza")));

        return p;
    }

    private String trimValue(String value) {
        return (value == null) ? "" : value.trim();
    }
}