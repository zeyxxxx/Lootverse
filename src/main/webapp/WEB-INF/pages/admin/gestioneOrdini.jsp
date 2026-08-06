<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <h2>Gestione Tutti gli Ordini (Admin)</h2>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID Ordine</th>
                    <th>ID Utente</th>
                    <th>Totale</th>
                    <th>Stato Attuale</th>
                    <th>Cambia Stato</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${ordini}">
                    <tr>
                        <td>#${o.idOrdine}</td>
                        <td>Utente #${o.idUtente}</td>
                        <td>€ <fmt:formatNumber value="${o.prezzoTotale}" pattern="0.00" /></td>
                        <td><strong>${o.stato}</strong></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin-ordini" method="post" class="inline-form">
                                <input type="hidden" name="idOrdine" value="${o.idOrdine}">
                                <select name="nuovoStato" class="select-status">
                                    <option value="In Elaborazione" ${o.stato == 'In Elaborazione' ? 'selected' : ''}>In Elaborazione</option>
                                    <option value="Spedito" ${o.stato == 'Spedito' ? 'selected' : ''}>Spedito</option>
                                    <option value="Consegnato" ${o.stato == 'Consegnato' ? 'selected' : ''}>Consegnato</option>
                                </select>
                                <button type="submit" class="btn btn-update">Aggiorna</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>