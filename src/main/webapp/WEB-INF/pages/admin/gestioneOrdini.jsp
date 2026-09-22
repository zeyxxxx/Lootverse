<%-- ==============================================================================
     Pagina JSP: Gestione Ordini (Pannello Admin)
     Descrizione: Interfaccia per visualizzare tutti gli ordini registrati nel sistema,
                  filtrare gli ordini per ID utente o per intervallo di date,
                  aggiornare lo stato di avanzamento di ciascun ordine (In lavorazione,
                  Spedito, Consegnato, Annullato, Rimborsato) e accedere ai dettagli dei prodotti.
     Inoltrata da: GestioneOrdiniServlet (GET/POST /admin-ordini)
     Dati in ingresso:
       - requestScope.ordini (List<Ordine>): elenco degli ordini estratti (tutti o filtrati)
       - requestScope.filtroApplicato (String): stringa riassuntiva del filtro corrente
       - requestScope.errore (String): eventuale messaggio di errore riscontrato
       - sessionScope.messaggioSuccesso (String): notifica flash di avvenuto aggiornamento stato
       - param.idUtente / param.dataInizio / param.dataFine: parametri GET per mantenere i filtri
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <%-- Inclusione frammento intestazione comune (meta, favicon, font) --%>
    <jsp:include page="/WEB-INF/fragments/header.jsp" />
    <%-- Foglio di stile dedicato per la dashboard di gestione ordini --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/gestioneOrdini.css">
    <title>Gestione Ordini - Admin</title>
</head>
<body>
    <%-- Barra di navigazione del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    
    <%-- Contenitore principale per il pannello amministrativo ordini --%>
    <main class="admin-container">
        <%-- Barra superiore decorativa con badge HUD cyberpunk --%>
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

        <%-- Notifica flash di successo memorizzata in sessione (rimossa dopo la visualizzazione) --%>
        <c:if test="${not empty sessionScope.messaggioSuccesso}">
            <div class="alert alert-success">
                ${sessionScope.messaggioSuccesso}
                <c:remove var="messaggioSuccesso" scope="session"/>
            </div>
        </c:if>
        
        <%-- Messaggio di allerta in caso di errore di validazione o aggiornamento stato --%>
        <c:if test="${not empty errore}">
            <div class="alert alert-error">
                ${errore}
            </div>
        </c:if>

        <%-- Notifica informativa relativa ai filtri attualmente attivi sull'elenco --%>
        <c:if test="${not empty filtroApplicato}">
            <div class="alert alert-success">
                Stai visualizzando ordini filtrati per: <strong>${filtroApplicato}</strong>
            </div>
        </c:if>

        <%-- Sezione filtri di ricerca per restringere la visualizzazione degli ordini --%>
        <div class="filter-container">
            <%-- Form di filtro per identificativo utente cliente --%>
            <form action="${pageContext.request.contextPath}/admin-ordini" method="get" class="filter-group">
                <label for="idUtente">Cerca per Utente (ID):</label>
                <input type="number" id="idUtente" name="idUtente" min="1" placeholder="Es. 4" value="${param.idUtente}">
                <button type="submit" class="btn-filter">Filtra Utente</button>
            </form>

            <%-- Form di filtro temporale per intervallo tra data di inizio e data di fine --%>
            <form action="${pageContext.request.contextPath}/admin-ordini" method="get" class="filter-group">
                <label for="dataInizio">Da:</label>
                <input type="date" id="dataInizio" name="dataInizio" value="${param.dataInizio}" required>
                
                <label for="dataFine">A:</label>
                <input type="date" id="dataFine" name="dataFine" value="${param.dataFine}" required>
                
                <button type="submit" class="btn-filter">Filtra Date</button>
            </form>

            <%-- Pulsante di reset per rimuovere ogni filtro e ricaricare l'elenco completo --%>
            <a href="${pageContext.request.contextPath}/admin-ordini" class="btn-clear">Rimuovi Filtri</a>
        </div>

        <%-- Tabella responsive con tutti gli ordini registrati --%>
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
                    <%-- Iterazione sugli ordini estratti dal database --%>
                    <c:forEach var="o" items="${ordini}">
                        <tr>
                            <td data-label="ID Ordine">#${o.idOrdine}</td>
                            <td data-label="ID Utente">Utente #${o.idUtente}</td>
                            <td data-label="Totale">€ <fmt:formatNumber value="${o.totale}" pattern="0.00" /></td>
                            <%-- Badge colorato corrispondente allo stato attuale dell'ordine --%>
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
                            <%-- Form rapido inline per l'aggiornamento dello stato --%>
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
                            <%-- Link alla schermata di dettaglio per visualizzare gli articoli acquistati --%>
                            <td data-label="Dettagli">
                                <a href="${pageContext.request.contextPath}/dettaglio-ordine?id=${o.idOrdine}" class="btn-view-products">Vedi Prodotti</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <%-- Messaggio visualizzato se nessun ordine corrisponde ai criteri --%>
                    <c:if test="${empty ordini}">
                        <tr>
                            <td colspan="6" class="empty-table-msg">Nessun ordine trovato.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
    
    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>