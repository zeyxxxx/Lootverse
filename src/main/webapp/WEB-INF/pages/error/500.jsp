<%-- ==============================================================================
     Pagina JSP: Errore 500 (Internal Server Error / Critical Failure)
     Descrizione: Schermata di cortesia presentata all'utente qualora si verifichi un'eccezione
                  non gestita o un'avaria critica a livello di server o database.
                  Evita l'esposizione di stack trace riservati all'utente finale.
     Attivazione: Intercettata dalla configurazione di gestione errori di Tomcat / web.xml
                  o inoltrata dai blocchi catch dei controller.
     Dati in ingresso:
       - requestScope.errore (String): eventuale messaggio descrittivo dell'eccezione
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile per le pagine di errore in stile Cyberpunk --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css?v=1">

<body>
    <%-- Barra di navigazione del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Pannello centrale di notifica guasto di sistema --%>
    <main class="container error-container">
        <div class="error-box">
            <%-- Codice numerico dell'errore interno del server HTTP 500 --%>
            <h1 class="error-code">500</h1>
            <h2>SYS.ERR: CRITICAL_FAILURE</h2>
            <%-- Dettaglio del guasto o messaggio rassicurante generico --%>
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty errore}">
                        ${errore}
                    </c:when>
                    <c:otherwise>
                        Il nucleo centrale ha subito un'avaria imprevista. I nostri droni stanno ripristinando il sistema.
                    </c:otherwise>
                </c:choose>
            </p>
            <%-- Pulsante per tornare al catalogo dei prodotti --%>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-return">Torna alla Base</a>
        </div>
    </main>

    <%-- Piè di pagina standard del portale --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>