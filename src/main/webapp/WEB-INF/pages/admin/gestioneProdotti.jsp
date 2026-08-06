<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <h2>Gestione Catalogo (Admin)</h2>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Prezzo</th>
                    <th>Disponibile</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${prodotti}">
                    <tr>
                        <td>#${p.idProdotto}</td>
                        <td>${p.nome}</td>
                        <td>€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${p.disponibilita}">Sì</c:when>
                                <c:otherwise>No</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin-prodotti?action=conferma-elimina&id=${p.idProdotto}" class="link-delete">Elimina</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>