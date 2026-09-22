<%-- ==============================================================================
     Pagina JSP: Errore 400 (Bad Request)
     Descrizione: Pagina personalizzata per la gestione dell'errore HTTP 400 (Richiesta non valida).
                  Presenta un messaggio tematico Cyberpunk/HUD indicante che i parametri inviati
                  al server non sono conformi o sono corrotti, permettendo all'utente di tornare
                  alla schermata del catalogo principale.
     Attivazione: Reindirizzamento esplicito o gestione di servlet container in caso di 400.
     Dati in ingresso:
       - requestScope.errore (String): messaggio esplicativo opzionale impostato dal controller
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con viewport e risorse globali --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per le pagine di errore tematiche --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css?v=1">

<body>
    <%-- Barra di navigazione del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Riquadro centrale di notifica errore --%>
    <main class="container error-container">
        <div class="error-box">
            <%-- Codice numerico dell'errore HTTP --%>
            <h1 class="error-code">400</h1>
            <h2>SYS.ERR: BAD_REQUEST</h2>
            <%-- Descrizione dell'errore (dinamica o messaggio predefinito) --%>
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty errore}">
                        ${errore}
                    </c:when>
                    <c:otherwise>
                        Sintassi invalida. I dati trasmessi sono corrotti o non processabili dal nucleo.
                    </c:otherwise>
                </c:choose>
            </p>
            <%-- Pulsante di ripristino navigazione verso il catalogo prodotti --%>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-return">Torna alla Base</a>
        </div>
    </main>

    <%-- Piè di pagina standard --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>