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
                <main class="container main-content">
                    <h2>Catalogo Prodotti</h2>
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
                </main>
                <jsp:include page="/WEB-INF/fragments/footer.jsp" />
            </body>

            </html>