
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/carrello.css?v=1">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module green-neon">SYS.LOG.CART</div>
            <div class="cyber-center-text green-neon">IL TUO CARRELLO</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-text green-neon">V. 1.0</div>
            </div>
        </div>
        
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty elementiCarrello}">
                <div class="empty-box">
                    <p>Il carrello è vuoto.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Esplora il Catalogo</a>
                </div>
            </c:when>
            <c:otherwise>
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Prodotto</th>
                            <th>Prezzo Unitario</th>
                            <th>Quantità</th>
                            <th>Subtotale</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${elementiCarrello}">
                            <tr>
                                <td data-label="Prodotto">
                                    <div class="cart-product-info">
                                        <c:choose>
                                            <c:when test="${not empty item.prodotto.immagine}">
                                                <img src="${pageContext.request.contextPath}/static/images/${item.prodotto.immagine}" alt="${item.prodotto.nome}" class="cart-product-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${item.prodotto.nome}" class="cart-product-img">
                                            </c:otherwise>
                                        </c:choose>
                                        <strong>${item.prodotto.nome}</strong>
                                    </div>
                                </td>
                                <td data-label="Prezzo Unitario">
                                    <div class="cart-price-info">
                                        <div class="prices-row">
                                            <c:choose>
                                                <c:when test="${item.prodotto.sconto > 0}">
                                                    <span class="old-price">€ <fmt:formatNumber value="${item.prodotto.prezzoIvato}" pattern="0.00" /></span>
                                                    <span class="final-price">€ <fmt:formatNumber value="${item.prodotto.prezzoFinale}" pattern="0.00" /></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="final-price">€ <fmt:formatNumber value="${item.prodotto.prezzoFinale}" pattern="0.00" /></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <span class="iva-info">(IVA inclusa)</span>
                                    </div>
                                </td>
                                <td data-label="Quantità">
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="idProdotto" value="${item.prodotto.idProdotto}">
                                        <input type="number" name="quantita" value="${item.quantita}" min="1" class="qty-input">
                                        <button type="submit" class="btn btn-update">Modifica</button>
                                    </form>
                                </td>
                                <td data-label="Subtotale">€ <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></td>
                                <td data-label="Azioni">
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="idProdotto" value="${item.prodotto.idProdotto}">
                                        <button type="submit" class="btn btn-remove">Rimuovi</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="cart-summary">
                    <h3>Totale Ordine: € <fmt:formatNumber value="${totaleCarrello}" pattern="0.00" /> <span class="tax-included">(IVA inclusa)</span></h3>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-checkout">Procedi al Checkout ➔</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>