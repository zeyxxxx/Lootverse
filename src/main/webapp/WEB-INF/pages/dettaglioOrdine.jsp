<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/dettaglioOrdine.css">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <div class="cyber-divider-wrapper hide-on-print">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module">SYS.LOG.ORDER</div>
            <div class="cyber-center-text">DETTAGLIO ORDINE</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-text">V. 1.0</div>
            </div>
        </div>

        <div class="order-header-info">
            <h2 class="print-only">Dettagli del tuo Ordine</h2>
            <div class="cyber-info-container">
                <p class="cyber-info-line"><span class="cyber-label">DATA:</span> <span class="cyber-value">${ordine.data}</span></p>
                <p class="cyber-info-line hide-on-print"><span class="cyber-label">STATO:</span> <span class="status-badge status-${ordine.stato.replaceAll('\\s+', '').toLowerCase()}">${ordine.stato}</span></p>
            </div>
        </div>

        <div class="product-list-container">
            <c:choose>
                <c:when test="${empty dettagliItems}">
                    <p class="error-text">Nessun prodotto trovato per questo ordine.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${dettagliItems}">
                        <div class="product-card">
                            <div class="product-img-wrapper">
                                <c:choose>
                                    <c:when test="${not empty item.prodotto.immagine}">
                                        <img src="${pageContext.request.contextPath}/static/images/${item.prodotto.immagine}" alt="${item.prodotto.nome}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${item.prodotto.nome}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="product-info">
                                <h3>${item.prodotto.nome}</h3>
                                <p class="qty">Quantità: <span>${item.dettaglio.quantita}</span></p>
                                <p class="price">Prezzo pagato cad.: € <fmt:formatNumber value="${item.dettaglio.prezzo}" pattern="0.00" /></p>
                                <p class="subtotal">Subtotale riga: € <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></p>
                            </div>
                            <div class="product-action">
                                <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${item.prodotto.idProdotto}" class="btn btn-primary">Vedi Prodotto</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="order-total-summary">
            <h3>Totale Ordine: <span class="total-price">€ <fmt:formatNumber value="${ordine.totale}" pattern="0.00" /></span></h3>
            <button onclick="window.print()" class="btn btn-primary btn-print">🖨️ Stampa Fattura / Salva PDF</button>
            <a href="${pageContext.request.contextPath}${isAdmin ? '/admin-ordini' : '/storico-ordini'}" class="btn btn-secondary">⬅ Torna allo Storico</a>
        </div>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>
