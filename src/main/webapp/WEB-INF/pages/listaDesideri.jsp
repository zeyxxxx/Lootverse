<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <h2>Wishlist </h2>
        <c:choose>
            <c:when test="${empty preferiti}">
                <p>La tua Wishlist è vuota.</p>
            </c:when>
            <c:otherwise>
                <div class="wishlist-grid">
                    <c:forEach var="p" items="${preferiti}">
                        <div class="wishlist-card">
                            <h4>${p.nome}</h4>
                            <p class="product-price">€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></p>
                            <form action="${pageContext.request.contextPath}/lista-desideri" method="post" class="inline-form">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                <button type="submit" class="btn btn-danger">Rimuovi</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>