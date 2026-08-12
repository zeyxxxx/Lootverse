<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/confermaOrdine.css?v=2">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content centered-content">
        <c:if test="${not empty ordine}">
            <div class="order-success-box">
                <h1 class="success-title"> Ordine Confermato!</h1>
                <p>ID Ordine: <strong>#${ordine.idOrdine}</strong></p>
                <p>Totale Pagato: € <fmt:formatNumber value="${ordine.totale}" pattern="0.00" /></p>
                <p>Stato: <span class="status-badge status-inlavorazione">${ordine.stato}</span></p>
                <a href="${pageContext.request.contextPath}/storico-ordini" class="btn btn-primary">Vai ai Tuoi Ordini</a>
            </div>
        </c:if>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>