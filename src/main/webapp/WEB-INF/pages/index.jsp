<%-- ==============================================================================
     Pagina JSP: Home Page (Vetrina Principale del Portale)
     Descrizione: Schermata iniziale e punto di ingresso principale per i clienti di Lootverse.
                  Comprende:
                  1. Carosello Hero scorrevole in testata con prodotti in evidenza e slide di benvenuto.
                  2. Sezione "I PIÙ VENDUTI" (Best Sellers) con estetica neon Cyberpunk rosa.
                  3. Sezione "IN SCONTO" (Offerte Speciali) con accenti neon verdi.
                  4. Integrazione con la Wishlist (cuori interattivi) e il Carrello tramite form AJAX.
                  5. Logica JavaScript client-side per lo scorrimento automatico temporizzato del carosello.
     Inoltrata da: HomeServlet / IndexServlet (GET / o /home)
     Dati in ingresso:
       - requestScope.prodottiCarosello (List<Prodotto>): articoli selezionati per lo slider hero
       - requestScope.prodottiPiuVenduti (List<Prodotto>): top seller calcolati dalle vendite effettive
       - requestScope.prodottiScontati (List<Prodotto>): articoli con percentuale di sconto attiva
       - requestScope.prodottiWishlist (List<Prodotto>): preferiti dell'utente autenticato
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune contenente meta tag, font Cyberpunk e icone Google --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per la homepage e il carosello hero --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/index.css?v=99">

<body>
    <%-- Barra di navigazione globale del sito --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- SEZIONE 1: CAROSELLO HERO (BANNER SUPERIORE SCORREVOLE) --%>
    <section class="carousel-container">
        <div class="carousel-slides" id="carouselSlides">
            <c:choose>
                <%-- Visualizza i prodotti designati per il carosello hero se disponibili --%>
                <c:when test="${not empty prodottiCarosello}">
                    <c:forEach var="p" items="${prodottiCarosello}" varStatus="status">
                        <div class="carousel-slide ${status.first ? 'active' : ''}">
                            <c:choose>
                                <c:when test="${not empty p.immagineCarosello}">
                                    <img src="${pageContext.request.contextPath}/static/images/${p.immagineCarosello}"
                                        alt="${p.nome}">
                                </c:when>
                                <c:when test="${not empty p.immagine}">
                                    <img src="${pageContext.request.contextPath}/static/images/${p.immagine}"
                                        alt="${p.nome}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/default.jpg"
                                        alt="${p.nome}">
                                </c:otherwise>
                            </c:choose>
                            <div class="carousel-caption">
                                <h2>${p.nome}</h2>
                                <p>${p.descrizione}</p>
                                <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}"
                                    class="btn btn-primary">Scopri di più</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <%-- Slide predefinita di fallback qualora non vi siano articoli specifici a DB --%>
                <c:otherwise>
                    <div class="carousel-slide active">
                        <img src="${pageContext.request.contextPath}/static/images/default.jpg"
                            alt="Lootverse">
                        <div class="carousel-caption">
                            <h2>BENVENUTO SU LOOTVERSE</h2>
                            <p>Scopri il meglio del nostro catalogo.</p>
                            <a href="${pageContext.request.contextPath}/catalogo"
                                class="btn btn-primary">Vai al Catalogo</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- Controlli di navigazione manuale avanti / indietro per le slide --%>
        <button class="carousel-btn prev" onclick="moveSlide(-1)" title="Slide precedente">❮</button>
        <button class="carousel-btn next" onclick="moveSlide(1)" title="Slide successiva">❯</button>
    </section>

    <%-- SEZIONE 2: VETRINA "I PIÙ VENDUTI" (BEST SELLERS) --%>
    <main class="container main-content">
        <%-- Barra HUD divisoria a tema neon rosa --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module pink-neon">// MODULE.BESTSELLERS loading...</div>
            <div class="cyber-center-text pink-neon">I PIÙ VENDUTI</div>
            <div class="cyber-right-hud pink-neon">
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-text pink-neon">SYS.DAT_98</div>
            </div>
        </div>

        <%-- Collegamento rapido al catalogo filtrabile --%>
        <div class="cyber-link-container">
            <a href="${pageContext.request.contextPath}/catalogo" class="cyber-link-catalogo pink-neon">Vedi tutto il catalogo ➔</a>
        </div>

        <%-- Griglia delle card per gli articoli più venduti --%>
        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty prodottiPiuVenduti}">
                    <c:forEach var="p" items="${prodottiPiuVenduti}">
                        <div class="product-card">

                            <%-- Verifica preliminare se l'articolo è presente nella wishlist utente --%>
                            <c:set var="inWishlist" value="false" />
                            <c:if test="${not empty prodottiWishlist}">
                                <c:forEach var="fav" items="${prodottiWishlist}">
                                    <c:if test="${fav.idProdotto == p.idProdotto}">
                                        <c:set var="inWishlist" value="true" />
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <%-- Modulo con bottone a forma di cuore gestito asincronamente da listaDesideriOverlay --%>
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

                            <%-- Thumbnail del prodotto --%>
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
                            
                            <%-- Prezzi, sconti e badge Best Seller --%>
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
                                <span class="best-seller-badge" title="Più Venduto">🔥 BEST SELLER</span>
                                <span class="tax-included">(IVA inclusa)</span>
                            </p>

                            <%-- Pulsanti d'azione (Dettagli e Aggiungi al Carrello rapido via AJAX) --%>
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
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Nessun prodotto disponibile al momento.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- SEZIONE 3: VETRINA "IN SCONTO" (OFFERTE SPECIALI) --%>
        <div class="cyber-divider-wrapper sconto-divider">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module green-neon">// MODULE.OFFERS loading...</div>
            <div class="cyber-center-text green-neon">IN SCONTO</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-text green-neon">SYS.DAT_42</div>
            </div>
        </div>

        <%-- Collegamento al catalogo completo con filtro sconti --%>
        <div class="cyber-link-container">
            <a href="${pageContext.request.contextPath}/catalogo" class="cyber-link-catalogo green-neon">Vedi tutto il catalogo ➔</a>
        </div>

        <%-- Griglia delle card per gli articoli in promozione --%>
        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty prodottiScontati}">
                    <c:forEach var="p" items="${prodottiScontati}">
                        <div class="product-card">

                            <%-- Verifica Best Seller per prodotti in sconto --%>
                            <c:set var="isBestSeller" value="false" />
                            <c:if test="${not empty prodottiPiuVenduti}">
                                <c:forEach var="bs" items="${prodottiPiuVenduti}">
                                    <c:if test="${bs.idProdotto == p.idProdotto}">
                                        <c:set var="isBestSeller" value="true" />
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <%-- Verifica Wishlist per prodotti in sconto --%>
                            <c:set var="inWishlist" value="false" />
                            <c:if test="${not empty prodottiWishlist}">
                                <c:forEach var="fav" items="${prodottiWishlist}">
                                    <c:if test="${fav.idProdotto == p.idProdotto}">
                                        <c:set var="inWishlist" value="true" />
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <%-- Pulsante Wishlist dinamico --%>
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

                            <%-- Thumbnail del prodotto --%>
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
                            
                            <%-- Prezzo scontato con evidenza del risparmio --%>
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
                                <c:if test="${isBestSeller}">
                                    <span class="best-seller-badge" title="Più Venduto">🔥 BEST SELLER</span>
                                </c:if>
                                <c:if test="${p.sconto > 0}">
                                    <span class="discount-badge" title="In offerta!">-<fmt:formatNumber value="${p.sconto}" pattern="0.##" />%</span>
                                </c:if>
                                <span class="tax-included">(IVA inclusa)</span>
                            </p>

                            <%-- Azioni rapide di scheda e carrello --%>
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
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Nessun prodotto in offerta al momento.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <%-- Inclusione del piè di pagina standard --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />

    <%-- Script JavaScript per lo scorrimento ciclico e automatico del carosello hero --%>
    <script>
        let currentSlide = 0;
        const slides = document.querySelectorAll('.carousel-slide');

        // Mostra una specifica slide rimuovendo la classe 'active' da tutte le altre
        function showSlide(index) {
            slides.forEach((slide, i) => {
                slide.classList.remove('active');
                if (i === index) slide.classList.add('active');
            });
        }

        // Incrementa o decrementa l'indice della slide corrente con gestione ad anello
        function moveSlide(direction) {
            if (slides.length <= 1) return;
            currentSlide += direction;
            if (currentSlide >= slides.length) currentSlide = 0;
            if (currentSlide < 0) currentSlide = slides.length - 1;
            showSlide(currentSlide);
        }

        // Avvia il timer di scorrimento automatico (ogni 5 secondi) se sono presenti più slide
        if (slides.length > 1) {
            setInterval(() => moveSlide(1), 5000);
        }
    </script>
</body>
</html>