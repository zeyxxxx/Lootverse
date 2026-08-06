<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content centered-content">
        <h2>Sei sicuro di voler eliminare il prodotto?</h2>
        <p>Prodotto: <strong>${prodotto.nome}</strong></p>

        <form action="${pageContext.request.contextPath}/admin-prodotti" method="post" class="confirm-form">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">
            <button type="submit" class="btn btn-danger">Sì, Elimina</button>
            <a href="${pageContext.request.contextPath}/admin-prodotti" class="btn btn-secondary">Annulla</a>
        </form>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>