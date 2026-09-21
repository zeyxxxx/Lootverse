<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/listaDesideri.css?v=1">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module pink-neon">SYS.LOG.WISHLIST</div>
            <div class="cyber-center-text pink-neon">LA TUA WISHLIST</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line pink-neon"></div>
                <div class="cyber-hud-line pink-neon"></div>
                <div class="cyber-hud-line pink-neon"></div>
                <div class="cyber-hud-text pink-neon">V. 1.0</div>
            </div>
        </div>
        <c:choose>
            <c:when test="${empty prodottiWishlist}">
                <div class="empty-box">
                    <p>La tua Wishlist è vuota.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Esplora il Catalogo</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="wishlist-grid">
                    <c:forEach var="p" items="${prodottiWishlist}">
                        <div class="wishlist-card">
                            <c:choose>
                                <c:when test="${not empty p.immagine}">
                                    <img src="${pageContext.request.contextPath}/static/images/${p.immagine}" alt="${p.nome}" class="wishlist-card-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${p.nome}" class="wishlist-card-img">
                                </c:otherwise>
                            </c:choose>

                            <h4>${p.nome}</h4>
                            <c:choose>
                                <c:when test="${p.sconto > 0}">
                                    <p class="product-price">
                                        <span class="old-price">€ <fmt:formatNumber value="${p.prezzoIvato}" pattern="0.00" /></span> 
                                        € <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" />
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="product-price">€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></p>
                                </c:otherwise>
                            </c:choose>
                            <p class="iva-label">(IVA inclusa)</p>

                            <div class="wishlist-actions">
                                <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form cart-form">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                    <input type="hidden" name="quantita" value="1">
                                    <button type="submit" class="btn btn-primary">Aggiungi 🛒</button>
                                </form>

                                <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}" class="btn btn-secondary">Dettagli</a>

                                <form action="${pageContext.request.contextPath}/lista-desideri" method="post" class="inline-form">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                    <button type="submit" class="btn-remove-wishlist">Rimuovi</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>