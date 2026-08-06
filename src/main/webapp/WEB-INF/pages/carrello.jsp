
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <h2>Il tuo Carrello <c:if test="${not empty carrello}">(ID: #${carrello.idCarrello})</c:if></h2>
        
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
                                <td><strong>${item.prodotto.nome}</strong></td>
                                <td>€ <fmt:formatNumber value="${item.prodotto.prezzoFinale}" pattern="0.00" /></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="idProdotto" value="${item.prodotto.idProdotto}">
                                        <input type="number" name="quantita" value="${item.quantita}" min="1" class="qty-input">
                                        <button type="submit" class="btn btn-update">Modifica</button>
                                    </form>
                                </td>
                                <td>€ <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></td>
                                <td>
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
                    <h3>Totale Ordine: € <fmt:formatNumber value="${totaleCarrello}" pattern="0.00" /></h3>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success">Checkout</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>