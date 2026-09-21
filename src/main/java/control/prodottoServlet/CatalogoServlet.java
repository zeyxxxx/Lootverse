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

/*
 Servlet per la gestione del Catalogo completo dei prodotti.
 Gestisce la consultazione degli articoli con molteplici filtri combinabili:
 fascia di prezzo (min/max), solo prodotti in sconto, solo bestseller,
 tipologia di arma, tipo di media, mondo di provenienza e ricerca testuale per nome.
 Risponde all'URL '/catalogo'.
*/
@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     Gestisce le richieste HTTP GET.
     Legge tutti i parametri dei filtri selezionati dall'utente nella sidebar,
     li rimette nella request per mantenere lo stato dei form/checkbox nella JSP,
     carica tutti i prodotti e i bestseller dal database tramite ProdottoDao,
     applica i filtri tramite Stream API di Java,
     estrae la lista dei mondi di provenienza per il menu a tendina
     e inoltra i prodotti filtrati alla pagina 'catalogo.jsp'.
    */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdottoDao prodottoDao = new ProdottoDao();

        try {
            // 1. Recupero dei parametri inviati dai filtri
            String minPriceStr = request.getParameter("prezzoMin");
            String maxPriceStr = request.getParameter("prezzoMax");
            String scontoSoloStr = request.getParameter("scontoSolo");
            String bestSellerSoloStr = request.getParameter("bestSellerSolo");
            String tipoArma = request.getParameter("tipoArma");
            String tipoMedia = request.getParameter("tipoMedia");
            String mondoProvenienza = request.getParameter("mondoProvenienza");
            String searchQuery = request.getParameter("searchQuery");

            // 2. Reinserimento dei parametri nella richiesta per mantenere lo stato dei filtri nella JSP
            request.setAttribute("prezzoMin", minPriceStr);
            request.setAttribute("prezzoMax", maxPriceStr);
            request.setAttribute("scontoSolo", scontoSoloStr);
            request.setAttribute("bestSellerSolo", bestSellerSoloStr);
            request.setAttribute("tipoArma", tipoArma);
            request.setAttribute("tipoMedia", tipoMedia);
            request.setAttribute("mondoProvenienza", mondoProvenienza);
            request.setAttribute("searchQuery", searchQuery);

            // 3. Recupero di tutti i prodotti e dei bestseller dal database
            Collection<ProdottoBean> tuttiProdotti = prodottoDao.doRetrieveAll();
            Collection<ProdottoBean> bestSellers = prodottoDao.doRetrieveBestSellers(8);
            
            // Estrazione degli ID dei bestseller per filtrare rapidamente
            java.util.Set<Integer> bestSellerIds = bestSellers.stream()
                .map(ProdottoBean::getIdProdotto)
                .collect(Collectors.toSet());

            // 4. Logica di filtraggio combinata tramite Stream API
            Collection<ProdottoBean> prodotti = tuttiProdotti.stream().filter(p -> {
                // Controllo prezzo minimo
                if (minPriceStr != null && !minPriceStr.isEmpty()) {
                    try { if (p.getPrezzoFinale() < Double.parseDouble(minPriceStr)) return false; } catch (Exception e) {}
                }
                // Controllo prezzo massimo
                if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                    try { if (p.getPrezzoFinale() > Double.parseDouble(maxPriceStr)) return false; } catch (Exception e) {}
                }
                
                // Controllo solo in sconto
                if ("true".equals(scontoSoloStr) && p.getSconto() <= 0) {
                    return false;
                }
                
                // Controllo solo bestseller
                if ("true".equals(bestSellerSoloStr) && !bestSellerIds.contains(p.getIdProdotto())) {
                    return false;
                }
                
                // Filtro per tipologia di arma
                if (tipoArma != null && !tipoArma.isEmpty() && !tipoArma.equalsIgnoreCase(p.getTipoArma())) {
                    return false;
                }
                
                // Filtro per tipologia di media
                if (tipoMedia != null && !tipoMedia.isEmpty() && !tipoMedia.equalsIgnoreCase(p.getTipoMedia())) {
                    return false;
                }
                
                // Filtro per universo o mondo di provenienza
                if (mondoProvenienza != null && !mondoProvenienza.isEmpty() && !mondoProvenienza.equalsIgnoreCase(p.getMondoProvenienza())) {
                    return false;
                }
                
                // Ricerca testuale per corrispondenza nel nome
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    if (p.getNome() == null || !p.getNome().toLowerCase().contains(searchQuery.toLowerCase().trim())) {
                        return false;
                    }
                }
                
                return true;
            }).collect(Collectors.toList());

            request.setAttribute("prodotti", prodotti);
            request.setAttribute("bestSellers", bestSellers);

            // 5. Recupero dell'elenco univoco dei mondi di provenienza per il menu a tendina
            Collection<String> mondiProvenienzaList = prodottoDao.doRetrieveAllMondiProvenienza();
            request.setAttribute("mondiProvenienzaList", mondiProvenienzaList);

            // Recupero della Wishlist se l'utente e loggato
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

    /*
     Inoltra le richieste POST al metodo doGet per consentire l'applicazione dei filtri anche via form POST.
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}