<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
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
                                <h3>${p.nome}</h3>
                                <p class="product-desc">${p.descrizione}</p>
                                <p class="product-material">Materiale: ${p.materiale}</p>
                                <p class="product-price">
                                    <strong>€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></strong>
                                </p>

                                <div class="product-actions">
                                    <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}" class="btn btn-secondary">Dettagli</a>
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                        <input type="hidden" name="quantita" value="1">
                                        <button type="submit" class="btn btn-primary">Aggiungi 🛒</button>
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