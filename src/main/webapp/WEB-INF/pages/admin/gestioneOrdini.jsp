<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <jsp:include page="/WEB-INF/fragments/header.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/gestioneOrdini.css">
    <title>Gestione Ordini - Admin</title>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    
    <main class="admin-container">
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module red-neon">SYS.ADMIN.ORDERS</div>
            <div class="cyber-center-text red-neon">GESTIONE ORDINI</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line red-neon"></div>
                <div class="cyber-hud-line red-neon"></div>
                <div class="cyber-hud-line red-neon"></div>
                <div class="cyber-hud-text red-neon">ROOT</div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.messaggioSuccesso}">
            <div class="alert alert-success">
                ${sessionScope.messaggioSuccesso}
                <c:remove var="messaggioSuccesso" scope="session"/>
            </div>
        </c:if>
        
        <c:if test="${not empty errore}">
            <div class="alert alert-error">
                ${errore}
            </div>
        </c:if>

        <c:if test="${not empty filtroApplicato}">
            <div class="alert alert-success">
                Stai visualizzando ordini filtrati per: <strong>${filtroApplicato}</strong>
            </div>
        </c:if>

        <!-- Filtri Form -->
        <div class="filter-container">
            <!-- Filtro per ID Utente -->
            <form action="${pageContext.request.contextPath}/admin-ordini" method="get" class="filter-group">
                <label for="idUtente">Cerca per Utente (ID):</label>
                <input type="number" id="idUtente" name="idUtente" min="1" placeholder="Es. 4" value="${param.idUtente}">
                <button type="submit" class="btn-filter">Filtra Utente</button>
            </form>

            <!-- Filtro per Data -->
            <form action="${pageContext.request.contextPath}/admin-ordini" method="get" class="filter-group">
                <label for="dataInizio">Da:</label>
                <input type="date" id="dataInizio" name="dataInizio" value="${param.dataInizio}" required>
                
                <label for="dataFine">A:</label>
                <input type="date" id="dataFine" name="dataFine" value="${param.dataFine}" required>
                
                <button type="submit" class="btn-filter">Filtra Date</button>
            </form>

            <!-- Bottone Pulisci Filtri -->
            <a href="${pageContext.request.contextPath}/admin-ordini" class="btn-clear">Rimuovi Filtri</a>
        </div>

        <div class="table-responsive">
            <table class="cyber-table">
                <thead>
                    <tr>
                        <th>ID Ordine</th>
                        <th>ID Utente</th>
                        <th>Totale</th>
                        <th>Stato Attuale</th>
                        <th>Cambia Stato</th>
                        <th>Dettagli</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${ordini}">
                        <tr>
                            <td data-label="ID Ordine">#${o.idOrdine}</td>
                            <td data-label="ID Utente">Utente #${o.idUtente}</td>
                            <td data-label="Totale">€ <fmt:formatNumber value="${o.totale}" pattern="0.00" /></td>
                            <td data-label="Stato Attuale">
                                <c:choose>
                                    <c:when test="${o.stato == 'In lavorazione'}">
                                        <span class="status-badge status-elaborazione">${o.stato}</span>
                                    </c:when>
                                    <c:when test="${o.stato == 'Spedito'}">
                                        <span class="status-badge status-spedito">${o.stato}</span>
                                    </c:when>
                                    <c:when test="${o.stato == 'Consegnato'}">
                                        <span class="status-badge status-consegnato">${o.stato}</span>
                                    </c:when>
                                    <c:when test="${o.stato == 'Annullato'}">
                                        <span class="status-badge status-annullato">${o.stato}</span>
                                    </c:when>
                                    <c:when test="${o.stato == 'Rimborsato'}">
                                        <span class="status-badge status-rimborsato">${o.stato}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-elaborazione">${o.stato}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Cambia Stato">
                                <form action="${pageContext.request.contextPath}/admin-ordini" method="post" class="inline-form">
                                    <input type="hidden" name="action" value="updateStato">
                                    <input type="hidden" name="idOrdine" value="${o.idOrdine}">
                                    <select name="nuovoStato" class="select-status">
                                        <option value="In lavorazione" ${o.stato == 'In lavorazione' ? 'selected' : ''}>In lavorazione</option>
                                        <option value="Spedito" ${o.stato == 'Spedito' ? 'selected' : ''}>Spedito</option>
                                        <option value="Consegnato" ${o.stato == 'Consegnato' ? 'selected' : ''}>Consegnato</option>
                                        <option value="Annullato" ${o.stato == 'Annullato' ? 'selected' : ''}>Annullato</option>
                                        <option value="Rimborsato" ${o.stato == 'Rimborsato' ? 'selected' : ''}>Rimborsato</option>
                                    </select>
                                    <button type="submit" class="btn-update">Aggiorna</button>
                                </form>
                            </td>
                            <td data-label="Dettagli">
                                <a href="${pageContext.request.contextPath}/dettaglio-ordine?id=${o.idOrdine}" class="btn-view-products">Vedi Prodotti</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty ordini}">
                        <tr>
                            <td colspan="6" class="empty-table-msg">Nessun ordine trovato.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>