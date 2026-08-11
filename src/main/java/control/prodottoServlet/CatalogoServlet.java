package control.prodottoServlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.listaDesideri.ListaDesideriBean;
import model.listaDesideri.ListaDesideriDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDao;
import model.utente.UtenteBean;

import java.util.stream.Collectors;

@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdottoDao prodottoDao = new ProdottoDao();

        try {
            // 1. Fetch parameters
            String minPriceStr = request.getParameter("prezzoMin");
            String maxPriceStr = request.getParameter("prezzoMax");
            String scontoSoloStr = request.getParameter("scontoSolo");
            String bestSellerSoloStr = request.getParameter("bestSellerSolo");
            String tipoArma = request.getParameter("tipoArma");
            String tipoMedia = request.getParameter("tipoMedia");
            String mondoProvenienza = request.getParameter("mondoProvenienza");
            String searchQuery = request.getParameter("searchQuery");

            // 2. Pass parameters back to JSP to keep state
            request.setAttribute("prezzoMin", minPriceStr);
            request.setAttribute("prezzoMax", maxPriceStr);
            request.setAttribute("scontoSolo", scontoSoloStr);
            request.setAttribute("bestSellerSolo", bestSellerSoloStr);
            request.setAttribute("tipoArma", tipoArma);
            request.setAttribute("tipoMedia", tipoMedia);
            request.setAttribute("mondoProvenienza", mondoProvenienza);
            request.setAttribute("searchQuery", searchQuery);

            // 3. Fetch all products and bestsellers
            Collection<ProdottoBean> tuttiProdotti = prodottoDao.doRetrieveAll();
            Collection<ProdottoBean> bestSellers = prodottoDao.doRetrieveBestSellers(8);
            
            // Extract bestseller IDs for easy filtering
            java.util.Set<Integer> bestSellerIds = bestSellers.stream()
                .map(ProdottoBean::getIdProdotto)
                .collect(Collectors.toSet());

            // 4. Stream filter logic
            Collection<ProdottoBean> prodotti = tuttiProdotti.stream().filter(p -> {
                // Prezzo
                if (minPriceStr != null && !minPriceStr.isEmpty()) {
                    try { if (p.getPrezzoFinale() < Double.parseDouble(minPriceStr)) return false; } catch (Exception e) {}
                }
                if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                    try { if (p.getPrezzoFinale() > Double.parseDouble(maxPriceStr)) return false; } catch (Exception e) {}
                }
                
                // Sconto
                if ("true".equals(scontoSoloStr) && p.getSconto() <= 0) {
                    return false;
                }
                
                // Best Seller
                if ("true".equals(bestSellerSoloStr) && !bestSellerIds.contains(p.getIdProdotto())) {
                    return false;
                }
                
                // Tipo Arma
                if (tipoArma != null && !tipoArma.isEmpty() && !tipoArma.equalsIgnoreCase(p.getTipoArma())) {
                    return false;
                }
                
                // Tipo Media
                if (tipoMedia != null && !tipoMedia.isEmpty() && !tipoMedia.equalsIgnoreCase(p.getTipoMedia())) {
                    return false;
                }
                
                // Mondo Provenienza
                if (mondoProvenienza != null && !mondoProvenienza.isEmpty() && !mondoProvenienza.equalsIgnoreCase(p.getMondoProvenienza())) {
                    return false;
                }
                
                // Ricerca testuale per Nome
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    if (p.getNome() == null || !p.getNome().toLowerCase().contains(searchQuery.toLowerCase().trim())) {
                        return false;
                    }
                }
                
                return true;
            }).collect(Collectors.toList());

            request.setAttribute("prodotti", prodotti);
            request.setAttribute("bestSellers", bestSellers);

            // 5. Fetch all distinct "Mondi di Provenienza" for the select dropdown
            Collection<String> mondiProvenienzaList = prodottoDao.doRetrieveAllMondiProvenienza();
            request.setAttribute("mondiProvenienzaList", mondiProvenienzaList);

            // Recupero della Wishlist se l'utente è loggato
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("utenteLoggato") != null) {
                UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
                ListaDesideriDAO listaDAO = new ListaDesideriDAO();
                ListaDesideriBean lista = listaDAO.doRetrieveByUtente(utente.getIdUtente());
                if (lista != null) {
                    Collection<ProdottoBean> prodottiWishlist = listaDAO.doRetrieveProdotti(lista.getIdListaDesideri());
                    request.setAttribute("prodottiWishlist", prodottiWishlist);
                }
            }

            request.getRequestDispatcher("/WEB-INF/pages/catalogo.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il caricamento del catalogo.");
            request.getRequestDispatcher("/WEB-INF/pages/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}