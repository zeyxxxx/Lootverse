<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="it">
            <jsp:include page="/WEB-INF/fragments/header.jsp" />
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/index.css?v=99">

            <body>
                <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

                <%-- 🎠 BANNER CAROSELLO IN ALTO --%>
                    <section class="carousel-container">
                        <div class="carousel-slides" id="carouselSlides">
                            <c:choose>
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
                                <c:otherwise>
                                    <%-- Slide di default se il DB è vuoto --%>
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

                        <%-- Pulsanti Avanti / Indietro --%>
                            <button class="carousel-btn prev" onclick="moveSlide(-1)">❮</button>
                            <button class="carousel-btn next" onclick="moveSlide(1)">❯</button>
                    </section>

                    <%-- 🔥 SEZIONE PRODOTTI PIÙ VENDUTI --%>
                        <main class="container main-content">
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
                            <div class="cyber-link-container">
                                <a href="${pageContext.request.contextPath}/catalogo" class="cyber-link-catalogo pink-neon">Vedi tutto il catalogo ➔</a>
                            </div>

                            <div class="product-grid">
                                <c:choose>
                                    <c:when test="${not empty prodottiPiuVenduti}">
                                        <c:forEach var="p" items="${prodottiPiuVenduti}">
                                            <div class="product-card">

                                                <%-- 💖 CONTROLLO SE IL PRODOTTO È IN WISHLIST --%>
                                                    <c:set var="inWishlist" value="false" />
                                                    <c:if test="${not empty prodottiWishlist}">
                                                        <c:forEach var="fav" items="${prodottiWishlist}">
                                                            <c:if test="${fav.idProdotto == p.idProdotto}">
                                                                <c:set var="inWishlist" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>

                                                    <%-- 💖 PULSANTE WISHLIST DINAMICO CON CLASSE WISHLIST-FORM PER AJAX
                                                        --%>
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
                                                        <p class="product-price">
                                                            <strong>€
                                                                <fmt:formatNumber value="${p.prezzoFinale}"
                                                                    pattern="0.00" />
                                                            </strong>
                                                            <span class="best-seller-badge" title="Più Venduto">🔥 BEST
                                                                SELLER</span>
                                                            <span
                                                                style="font-size: 0.8rem; font-weight: normal; color: #aaa; display: block; margin-top: 5px;">(IVA
                                                                inclusa)</span>
                                                        </p>

                                                        <div class="product-actions">
                                                            <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}"
                                                                class="btn btn-secondary">Dettagli</a>
                                                            <form action="${pageContext.request.contextPath}/carrello"
                                                                method="post" class="inline-form">
                                                                <input type="hidden" name="action" value="add">
                                                                <input type="hidden" name="idProdotto"
                                                                    value="${p.idProdotto}">
                                                                <input type="hidden" name="quantita" value="1">
                                                                <button type="submit" class="btn btn-primary">Aggiungi
                                                                    🛒</button>
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

                            <div class="cyber-divider-wrapper" style="margin-top: 70px;">
                                <div class="cyber-divider"></div>
                                <div class="cyber-left-module">// MODULE.OFFERS loading...</div>
                                <div class="cyber-center-text">IN SCONTO</div>
                                <div class="cyber-right-hud">
                                    <div class="cyber-hud-line"></div>
                                    <div class="cyber-hud-line"></div>
                                    <div class="cyber-hud-line"></div>
                                    <div class="cyber-hud-text">SYS.DAT_42</div>
                                </div>
                            </div>
                            <div class="cyber-link-container">
                                <a href="${pageContext.request.contextPath}/catalogo" class="cyber-link-catalogo">Vedi tutto il catalogo ➔</a>
                            </div>

                            <div class="product-grid">
                                <c:choose>
                                    <c:when test="${not empty prodottiScontati}">
                                        <c:forEach var="p" items="${prodottiScontati}">
                                            <div class="product-card">

                                                <%-- 💖 CONTROLLO SE IL PRODOTTO È UN BEST SELLER --%>
                                                    <c:set var="isBestSeller" value="false" />
                                                    <c:if test="${not empty prodottiPiuVenduti}">
                                                        <c:forEach var="bs" items="${prodottiPiuVenduti}">
                                                            <c:if test="${bs.idProdotto == p.idProdotto}">
                                                                <c:set var="isBestSeller" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>

                                                <%-- 💖 CONTROLLO SE IL PRODOTTO È IN WISHLIST --%>
                                                    <c:set var="inWishlist" value="false" />
                                                    <c:if test="${not empty prodottiWishlist}">
                                                        <c:forEach var="fav" items="${prodottiWishlist}">
                                                            <c:if test="${fav.idProdotto == p.idProdotto}">
                                                                <c:set var="inWishlist" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>

                                                    <%-- 💖 PULSANTE WISHLIST DINAMICO --%>
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
                                                        <p class="product-price">
                                                            <strong>€
                                                                <fmt:formatNumber value="${p.prezzoFinale}"
                                                                    pattern="0.00" />
                                                            </strong>
                                                            <c:if test="${isBestSeller}">
                                                                <span class="best-seller-badge" title="Più Venduto">🔥 BEST SELLER</span>
                                                            </c:if>
                                                            <c:if test="${p.sconto > 0}">
                                                                <span class="discount-badge" title="In offerta!">-<fmt:formatNumber value="${p.sconto}" pattern="0.##" />%</span>
                                                            </c:if>
                                                            <span
                                                                style="font-size: 0.8rem; font-weight: normal; color: #aaa; display: block; margin-top: 5px;">(IVA
                                                                inclusa)</span>
                                                        </p>

                                                        <div class="product-actions">
                                                            <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}"
                                                                class="btn btn-secondary">Dettagli</a>
                                                            <form action="${pageContext.request.contextPath}/carrello"
                                                                method="post" class="inline-form">
                                                                <input type="hidden" name="action" value="add">
                                                                <input type="hidden" name="idProdotto"
                                                                    value="${p.idProdotto}">
                                                                <input type="hidden" name="quantita" value="1">
                                                                <button type="submit" class="btn btn-primary">Aggiungi
                                                                    🛒</button>
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

                        <jsp:include page="/WEB-INF/fragments/footer.jsp" />

                        <%-- Script JavaScript per far scorrere il carosello --%>
                            <script>
                                let currentSlide = 0;
                                const slides = document.querySelectorAll('.carousel-slide');

                                function showSlide(index) {
                                    slides.forEach((slide, i) => {
                                        slide.classList.remove('active');
                                        if (i === index) slide.classList.add('active');
                                    });
                                }

                                function moveSlide(direction) {
                                    if (slides.length <= 1) return;
                                    currentSlide += direction;
                                    if (currentSlide >= slides.length) currentSlide = 0;
                                    if (currentSlide < 0) currentSlide = slides.length - 1;
                                    showSlide(currentSlide);
                                }

                                if (slides.length > 1) {
                                    setInterval(() => moveSlide(1), 5000);
                                }
                            </script>
            </body>

            </html>