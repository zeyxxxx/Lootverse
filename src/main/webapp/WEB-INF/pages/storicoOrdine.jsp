<%-- ==============================================================================
     Pagina JSP: Storico Ordini (Elenco Ordini Utente)
     Descrizione: Mostra la cronologia completa degli acquisti effettuati dal cliente loggato.
                  Per ciascun ordine effettuato visualizza:
                  - Numero progressivo o identificativo d'ordine
                  - Badge colorato di stato avanzamento (In lavorazione, Spedito, Consegnato, ecc.)
                  - Data di registrazione
                  - Importo totale pagato
                  - Link diretto alla pagina di dettaglio dei prodotti e stampa fattura.
     Inoltrata da: StoricoOrdiniServlet (GET /storico-ordini)
     Dati in ingresso:
       - requestScope.ordini (List<Ordine>): collezione cronologica degli ordini dell'utente
       - requestScope.errore (String): eventuale messaggio di errore o sessione non valida
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con meta tag e risorse globali --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per la cronologia ordini --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/storicoOrdini.css">

<body>
    <%-- Barra di navigazione principale del sito --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione principale contenente le card degli ordini o il box vuoto --%>
    <main class="container main-content">
        <%-- Barra superiore decorativa HUD Cyberpunk con accenti neon blu --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module blue-neon">SYS.LOG.ORDERS</div>
            <div class="cyber-center-text blue-neon">I TUOI ORDINI</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line blue-neon"></div>
                <div class="cyber-hud-line blue-neon"></div>
                <div class="cyber-hud-line blue-neon"></div>
                <div class="cyber-hud-text blue-neon">V. 1.0</div>
            </div>
        </div>
        
        <%-- Notifica di errore di recupero ordini --%>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <%-- Caso 1: Nessun ordine registrato a nome dell'utente --%>
            <c:when test="${empty ordini}">
                <div class="empty-box">
                    <p>Non hai ancora effettuato ordini.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Vai al Catalogo</a>
                </div>
            </c:when>

            <%-- Caso 2: Elenco degli ordini estratti per l'utente corrente --%>
            <c:otherwise>
                <div class="ordini-container">
                    <%-- Iterazione sugli ordini in ordine cronologico decrescente --%>
                    <c:forEach var="ordine" items="${ordini}" varStatus="loop">
                        <div class="ordine-card">
                            <%-- Testata della card d'ordine con conteggio progressivo e badge di stato --%>
                            <div class="ordine-header">
                                <h3>Ordine #${fn:length(ordini) - loop.index}</h3>
                                <span class="status-badge status-${ordine.stato.replaceAll('\\s+', '').toLowerCase()}">${ordine.stato}</span>
                            </div>

                            <%-- Corpo informativo con data, importo totale e pulsante dettaglio --%>
                            <div class="ordine-body">
                                <p><strong>Data:</strong> ${ordine.data}</p>
                                <p><strong>Totale:</strong> € <fmt:formatNumber value="${ordine.totale}" pattern="0.00" /></p>
                                <a href="${pageContext.request.contextPath}/dettaglio-ordine?id=${ordine.idOrdine}" class="btn btn-secondary">Visualizza Prodotti ➔</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%-- Piè di pagina standard del portale --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>