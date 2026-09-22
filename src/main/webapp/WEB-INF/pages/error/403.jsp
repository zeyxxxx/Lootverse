<%-- ==============================================================================
     Pagina JSP: Errore 403 (Access Denied / Forbidden)
     Descrizione: Pagina di blocco accesso per violazione delle autorizzazioni di sicurezza.
                  Mostrata quando un utente non autenticato o privo dei privilegi di amministratore
                  tenta di accedere a risorse o pagine riservate.
     Attivazione: Intercettata dai filtri di sicurezza o dai controller in caso di permessi non validi.
     Dati in ingresso:
       - requestScope.errore (String): eventuale messaggio di dettaglio sul rifiuto d'accesso
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con meta tag e font --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per le schermate di errore --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css?v=1">

<body>
    <%-- Barra di navigazione principale del sito --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Pannello centrale di notifica accesso negato --%>
    <main class="container error-container">
        <div class="error-box">
            <%-- Codice numerico dell'errore di autorizzazione HTTP --%>
            <h1 class="error-code">403</h1>
            <h2>SYS.ERR: ACCESS_DENIED</h2>
            <%-- Descrizione dell'anomalia di autorizzazione --%>
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty errore}">
                        ${errore}
                    </c:when>
                    <c:otherwise>
                        Autorizzazione insufficiente. I sistemi di sicurezza ti hanno bloccato.
                    </c:otherwise>
                </c:choose>
            </p>
            <%-- Pulsante di navigazione per tornare in sicurezza al catalogo --%>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-return">Torna alla Base</a>
        </div>
    </main>

    <%-- Piè di pagina standard --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>