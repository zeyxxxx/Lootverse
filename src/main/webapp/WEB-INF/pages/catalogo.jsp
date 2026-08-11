<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="it">
            <jsp:include page="/WEB-INF/fragments/header.jsp" />
            <link rel="stylesheet" type="text/css"
                href="${pageContext.request.contextPath}/static/css/catalogo.css?v=99">

            <body>
                <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
                <main class="container main-content catalog-container">
                    <div class="cyber-divider-wrapper" style="margin-top: 20px; margin-bottom: 40px;">
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
                    <div class="catalog-layout">
                    
                    <!-- INIZIO SIDEBAR FILTRI -->
                    <aside class="catalog-sidebar form-box">
                        <h3>Filtri Ricerca</h3>
                        <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="filter-form">
                            <!-- Prezzo -->
                            <div class="form-group">
                                <label>Prezzo Min (€)</label>
                                <input type="number" name="prezzoMin" step="0.01" min="0" value="${prezzoMin}">
                            </div>
                            <div class="form-group">
                                <label>Prezzo Max (€)</label>
                                <input type="number" name="prezzoMax" step="0.01" min="0" value="${prezzoMax}">
                            </div>
                            
                            <!-- Checkbox Sconto / Best Seller -->
                            <div class="form-group checkbox-group" style="flex-direction: row; align-items: center; gap: 10px;">
                                <input type="checkbox" name="scontoSolo" value="true" ${scontoSolo == 'true' ? 'checked' : ''} id="scontoCheck">
                                <label for="scontoCheck" style="margin: 0; cursor: pointer;">Solo In Sconto</label>
                            </div>
                            <div class="form-group checkbox-group" style="flex-direction: row; align-items: center; gap: 10px;">
                                <input type="checkbox" name="bestSellerSolo" value="true" ${bestSellerSolo == 'true' ? 'checked' : ''} id="bsCheck">
                                <label for="bsCheck" style="margin: 0; cursor: pointer;">Solo Best Seller</label>
                            </div>

                            <!-- Tipo Arma -->
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

                            <!-- Tipo Media -->
                            <div class="form-group">
                                <label>Tipo Media</label>
                                <select name="tipoMedia">
                                    <option value="">Tutti</option>
                                    <option value="film" ${tipoMedia == 'film' ? 'selected' : ''}>Film</option>
                                    <option value="videogiochi" ${tipoMedia == 'videogiochi' ? 'selected' : ''}>Videogiochi</option>
                                    <option value="anime" ${tipoMedia == 'anime' ? 'selected' : ''}>Anime</option>
                                </select>
                            </div>

                            <!-- Mondo Provenienza (Dinamico) -->
                            <div class="form-group">
                                <label>Mondo di Provenienza</label>
                                <select name="mondoProvenienza">
                                    <option value="">Tutti</option>
                                    <c:forEach var="mondo" items="${mondiProvenienzaList}">
                                        <option value="${mondo}" ${mondoProvenienza == mondo ? 'selected' : ''}>${mondo}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary" style="width: 100%;">Applica Filtri</button>
                            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-secondary" style="width: 100%; margin-top: 10px; display: block; text-align: center;">Resetta</a>
                        </form>
                    </aside>
                    <!-- FINE SIDEBAR FILTRI -->

                    <div class="catalog-content">
                        <div class="product-grid">
                        <c:choose>
                            <c:when test="${not empty prodotti}">
                                <c:forEach var="p" items="${prodotti}">
                                    <c:if test="${p.disponibilita}">
                                        <div class="product-card">

                                            <%-- 💖 CONTROLLO SE IL PRODOTTO È UN BEST SELLER --%>
                                                <c:set var="isBestSeller" value="false" />
                                                <c:if test="${not empty bestSellers}">
                                                    <c:forEach var="bs" items="${bestSellers}">
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
                                                                <span class="best-seller-badge" title="Più Venduto">🔥 BEST
                                                                    SELLER</span>
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
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p>Nessun prodotto disponibile nel catalogo.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    </div> <!-- chiusura catalog-content -->
                    </div> <!-- chiusura catalog-layout -->
                </main>
                <jsp:include page="/WEB-INF/fragments/footer.jsp" />
            </body>

            </html>