<%-- ==============================================================================
     Pagina JSP: Catalogo Prodotti (Vetrina e Ricerca con Filtri)
     Descrizione: Vetrina principale dell'e-commerce Lootverse.
                  Offre una sidebar di filtraggio avanzato (prezzo min/max, solo sconti,
                  solo best seller, tipologia d'arma, tipologia media e mondo di provenienza)
                  adattabile a drawer mobile con overlay.
                  Nel corpo centrale visualizza la griglia responsive dei prodotti disponibili,
                  con calcolo dinamico dello stato di presenza in Wishlist, badge Best Seller / Sconto,
                  pulsante rapido per la lista desideri e pulsante di aggiunta al carrello via AJAX.
     Inoltrata da: CatalogoServlet (GET /catalogo)
     Dati in ingresso:
       - requestScope.prodotti (List<Prodotto>): collezione dei prodotti filtrati o complessivi
       - requestScope.bestSellers (List<Prodotto>): lista dei prodotti più venduti per attribuzione badge
       - requestScope.prodottiWishlist (List<Prodotto>): prodotti salvati nella lista desideri dell'utente
       - requestScope.mondiProvenienzaList (List<String>): elenco dinamico dei mondi fantasy/sci-fi
       - parametri GET (prezzoMin, prezzoMax, scontoSolo, bestSellerSolo, tipoArma, tipoMedia, mondoProvenienza)
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione del frammento header comune (meta viewport, font Google, favicon) --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il catalogo e la sidebar filtri --%>
<link rel="stylesheet" type="text/css"
    href="${pageContext.request.contextPath}/static/css/catalogo.css?v=99">

<body>
    <%-- Barra di navigazione globale del sito --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Contenitore principale della pagina catalogo --%>
    <main class="container main-content catalog-container">
        <%-- Barra superiore decorativa HUD Cyberpunk con accenti neon rosa --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module pink-neon">// MODULE.CATALOG loading...</div>
            <div class="cyber-center-text pink-neon">CATALOGO PRODOTTI</div>
            <div class="cyber-right-hud pink-neon">
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-text pink-neon">SYS.DAT_77</div>
            </div>
        </div>
        
        <%-- Pulsante di attivazione filtri per dispositivi mobili (schermi ridotti) --%>
        <div class="mobile-filter-container">
            <button id="mobileFilterBtn" class="btn btn-primary cyber-btn">
                Filtri di Ricerca
            </button>
        </div>

        <div class="catalog-layout">
        
        <%-- Sfondo oscurato (Backdrop) per la chiusura dei filtri mobile al tocco esterno --%>
        <div class="filter-overlay" id="filterOverlay"></div>
        
        <%-- SIDEBAR LATERALE DEI FILTRI DI RICERCA --%>
        <aside class="catalog-sidebar form-box" id="catalogSidebar">
            <div class="sidebar-header">
                <h3>Filtri Ricerca</h3>
                <%-- Pulsante a crocetta per chiudere la sidebar su smartphone --%>
                <button type="button" id="closeFilterBtn" class="close-filter-btn">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <%-- Modulo GET per inviare i criteri di raffinamento alla CatalogoServlet --%>
            <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="filter-form">
                <%-- Filtro per intervallo di prezzo minimo e massimo --%>
                <div class="form-group">
                    <label>Prezzo Min (€)</label>
                    <input type="number" name="prezzoMin" step="0.01" min="0" value="${prezzoMin}">
                </div>
                <div class="form-group">
                    <label>Prezzo Max (€)</label>
                    <input type="number" name="prezzoMax" step="0.01" min="0" value="${prezzoMax}">
                </div>
                
                <%-- Filtri rapidi booleani (offerte speciali e articoli più venduti) --%>
                <div class="form-group checkbox-group">
                    <input type="checkbox" name="scontoSolo" value="true" ${scontoSolo == 'true' ? 'checked' : ''} id="scontoCheck">
                    <label for="scontoCheck">Solo In Sconto</label>
                </div>
                <div class="form-group checkbox-group">
                    <input type="checkbox" name="bestSellerSolo" value="true" ${bestSellerSolo == 'true' ? 'checked' : ''} id="bsCheck">
                    <label for="bsCheck">Solo Best Seller</label>
                </div>

                <%-- Filtro per categoria tipologia d'arma --%>
                <div class="form-group">
                    <label>Tipo d'Arma</label>
                    <select name="tipoArma">
                        <option value="">Tutti</option>
                        <option value="spada" ${tipoArma == 'spada' ? 'selected' : ''}>Spada</option>
                        <option value="coltello" ${tipoArma == 'coltello' ? 'selected' : ''}>Coltello</option>
                        <option value="pistola" ${tipoArma == 'pistola' ? 'selected' : ''}>Pistola</option>
                        <option value="speciali" ${tipoArma == 'speciali' ? 'selected' : ''}>Speciali</option>
                    </select>
                </div>

                <%-- Filtro per tipologia di media (film, videogiochi, anime) --%>
                <div class="form-group">
                    <label>Tipo Media</label>
                    <select name="tipoMedia">
                        <option value="">Tutti</option>
                        <option value="film" ${tipoMedia == 'film' ? 'selected' : ''}>Film</option>
                        <option value="videogiochi" ${tipoMedia == 'videogiochi' ? 'selected' : ''}>Videogiochi</option>
                        <option value="anime" ${tipoMedia == 'anime' ? 'selected' : ''}>Anime</option>
                    </select>
                </div>

                <%-- Filtro dinamico per franchise o mondo narrativo di provenienza --%>
                <div class="form-group">
                    <label>Mondo di Provenienza</label>
                    <select name="mondoProvenienza">
                        <option value="">Tutti</option>
                        <c:forEach var="mondo" items="${mondiProvenienzaList}">
                            <option value="${mondo}" ${mondoProvenienza == mondo ? 'selected' : ''}>${mondo}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- Pulsanti di applicazione criteri e ripristino catalogo completo --%>
                <button type="submit" class="btn btn-primary">Applica Filtri</button>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-secondary">Resetta</a>
            </form>
        </aside>

        <%-- SEZIONE CONTENUTO PRINCIPALE: GRIGLIA PRODOTTI --%>
        <div class="catalog-content">
            <div class="product-grid">
            <c:choose>
                <c:when test="${not empty prodotti}">
                    <%-- Iterazione sui prodotti restituiti dalla query --%>
                    <c:forEach var="p" items="${prodotti}">
                        <%-- Mostra esclusivamente i prodotti con flag di disponibilità attivo --%>
                        <c:if test="${p.disponibilita}">
                            <div class="product-card">

                                <%-- Verifica se il prodotto appartiene alla lista dei più venduti (Best Seller) --%>
                                <c:set var="isBestSeller" value="false" />
                                <c:if test="${not empty bestSellers}">
                                    <c:forEach var="bs" items="${bestSellers}">
                                        <c:if test="${bs.idProdotto == p.idProdotto}">
                                            <c:set var="isBestSeller" value="true" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>

                                <%-- Verifica se il prodotto è già stato salvato nella wishlist dell'utente corrente --%>
                                <c:set var="inWishlist" value="false" />
                                <c:if test="${not empty prodottiWishlist}">
                                    <c:forEach var="fav" items="${prodottiWishlist}">
                                        <c:if test="${fav.idProdotto == p.idProdotto}">
                                            <c:set var="inWishlist" value="true" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>

                                <%-- Pulsante Wishlist asincrono con icona a forma di cuore dinamico --%>
                                <form action="${pageContext.request.contextPath}/lista-desideri"
                                    method="post" class="wishlist-form">
                                    <input type="hidden" name="action"
                                        value="${inWishlist ? 'remove' : 'add'}">
                                    <input type="hidden" name="idProdotto"
                                        value="${p.idProdotto}">
                                    <button type="submit"
                                        class="wishlist-btn ${inWishlist ? 'in-wishlist' : ''}"
                                        title="${inWishlist ? 'Rimuovi dalla Wishlist' : 'Aggiungi alla Wishlist'}">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </form>

                                <%-- Anteprima immagine del prodotto con fallback su default.jpg --%>
                                <c:choose>
                                    <c:when test="${not empty p.immagine}">
                                        <img src="${pageContext.request.contextPath}/static/images/${p.immagine}"
                                            alt="${p.nome}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/static/images/default.jpg"
                                            alt="${p.nome}">
                                    </c:otherwise>
                                </c:choose>

                                <h3>${p.nome}</h3>
                                <p class="product-desc">${p.descrizione}</p>

                                <%-- Visualizzazione del prezzo con eventuale prezzo barrato e badge di sconto --%>
                                <p class="product-price">
                                    <c:choose>
                                        <c:when test="${p.sconto > 0}">
                                            <span class="old-price">€ <fmt:formatNumber value="${p.prezzoIvato}" pattern="0.00" /></span>
                                            <strong>€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></strong>
                                        </c:when>
                                        <c:otherwise>
                                            <strong>€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></strong>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- Badge distintivo Best Seller --%>
                                    <c:if test="${isBestSeller}">
                                        <span class="best-seller-badge" title="Più Venduto">🔥 BEST SELLER</span>
                                    </c:if>

                                    <%-- Badge distintivo percentuale di sconto --%>
                                    <c:if test="${p.sconto > 0}">
                                        <span class="discount-badge" title="In offerta!">-<fmt:formatNumber value="${p.sconto}" pattern="0.##" />%</span>
                                    </c:if>
                                    <span class="tax-included">(IVA inclusa)</span>
                                </p>

                                <%-- Barra di azioni rapide della card (pulsante dettaglio e aggiunta al carrello) --%>
                                <div class="product-actions">
                                    <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}"
                                        class="btn btn-secondary">Dettagli</a>
                                    <form action="${pageContext.request.contextPath}/carrello"
                                        method="post" class="inline-form cart-form">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="idProdotto"
                                            value="${p.idProdotto}">
                                        <input type="hidden" name="quantita" value="1">
                                        <button type="submit" class="btn btn-primary">Aggiungi 🛒</button>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <%-- Messaggio di fallback qualora nessun prodotto corrisponda ai filtri --%>
                    <p>Nessun prodotto disponibile nel catalogo.</p>
                </c:otherwise>
            </c:choose>
            </div>
        </div>
        </div>
    </main>

    <%-- Piè di pagina globale del portale --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />

    <%-- Script JavaScript per l'interazione con il drawer mobile dei filtri --%>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const mobileFilterBtn = document.getElementById("mobileFilterBtn");
            const closeFilterBtn = document.getElementById("closeFilterBtn");
            const catalogSidebar = document.getElementById("catalogSidebar");
            const filterOverlay = document.getElementById("filterOverlay");

            // Alterna l'apertura/chiusura della barra laterale su mobile
            function toggleFilters() {
                catalogSidebar.classList.toggle("active");
                filterOverlay.classList.toggle("active");
                if(catalogSidebar.classList.contains("active")) {
                    document.body.style.overflow = "hidden"; // blocca lo scroll del body
                } else {
                    document.body.style.overflow = "";
                }
            }

            if(mobileFilterBtn && closeFilterBtn && catalogSidebar && filterOverlay) {
                mobileFilterBtn.addEventListener("click", toggleFilters);
                closeFilterBtn.addEventListener("click", toggleFilters);
                filterOverlay.addEventListener("click", toggleFilters);
            }
        });
    </script>
</body>
</html>