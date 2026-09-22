<%-- ==============================================================================
     Pagina JSP: Errore 404 (Not Found / Connection Lost)
     Descrizione: Pagina di errore mostrata qualora l'URL digitato o la risorsa richiesta
                  (prodotto, ordine, rotta servlet) non sia presente nel server o nel database.
     Attivazione: Intercettata dal container web o invocata esplicitamente tramite forward
                  in assenza di record corrispondenti.
     Dati in ingresso:
       - requestScope.errore (String): eventuale messaggio descrittivo dell'entità non trovata
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con intestazione del documento --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile per la visualizzazione della schermata di errore cyberpunk --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css?v=1">

<body>
    <%-- Barra di navigazione del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Riquadro centrale di notifica risorsa inesistente --%>
    <main class="container error-container">
        <div class="error-box">
            <%-- Codice numerico HTTP 404 --%>
            <h1 class="error-code">404</h1>
            <h2>SYS.ERR: CONNECTION_LOST</h2>
            <%-- Dettaglio descrittivo della risorsa non localizzata --%>
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty errore}">
                        ${errore}
                    </c:when>
                    <c:otherwise>
                        Segnale debole. La risorsa richiesta non esiste o è stata cancellata dai registri.
                    </c:otherwise>
                </c:choose>
            </p>
            <%-- Link per ritornare alla pagina principale del catalogo --%>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-return">Torna alla Base</a>
        </div>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>