<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <h2>Storico Ordini</h2>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty storicoOrdini}">
                <p>Non hai ancora effettuato ordini.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="itemOrdine" items="${storicoOrdini}">
                    <div class="order-card">
                        <h3>Ordine #${itemOrdine.ordine.idOrdine} — Stato: <span class="status-text">${itemOrdine.ordine.stato}</span></h3>
                        <p class="order-date">Data: ${itemOrdine.ordine.dataSpedizione}</p>
                        <ul class="order-items-list">
                            <c:forEach var="itemProd" items="${itemOrdine.prodottiAcquistati}">
                                <li>
                                    <strong>${itemProd.prodotto.nome}</strong> 
                                    x${itemProd.quantita} 
                                    (€ <fmt:formatNumber value="${itemProd.prezzoAcquisto}" pattern="0.00" /> cad.)
                                </li>
                            </c:forEach>
                        </ul>
                        <h4>Totale Ordine: € <fmt:formatNumber value="${itemOrdine.ordine.prezzoTotale}" pattern="0.00" /></h4>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>