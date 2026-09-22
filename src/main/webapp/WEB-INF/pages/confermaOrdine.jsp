<%-- ==============================================================================
     Pagina JSP: Conferma Ordine (Esito Positivo Transazione)
     Descrizione: Schermata di ringraziamento e notifica di successo mostrata all'utente
                  subito dopo che l'ordine è stato registrato nel database e il carrello svuotato.
                  Espone il codice identificativo dell'ordine generato (#ID), l'importo totale pagato,
                  lo stato iniziale dell'ordine ("In lavorazione") e un pulsante per consultare
                  lo storico completo degli acquisti personali.
     Inoltrata da: ConfermaOrdineServlet (POST /conferma-ordine tramite forward)
     Dati in ingresso:
       - requestScope.ordine (Ordine): bean dell'ordine appena creato e persistito
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con meta tag e risorse globali --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il riquadro di successo ordine --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/confermaOrdine.css?v=2">

<body>
    <%-- Barra di navigazione principale del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione centrale contenente il box di riepilogo dell'ordine completato --%>
    <main class="container main-content centered-content">
        <c:if test="${not empty ordine}">
            <div class="order-success-box">
                <%-- Titolo di avvenuta conferma con icona grafica --%>
                <h1 class="success-title"> Ordine Confermato!</h1>

                <%-- Dettagli identificativi e contabili dell'ordine --%>
                <p>ID Ordine: <strong>#${ordine.idOrdine}</strong></p>
                <p>Totale Pagato: € <fmt:formatNumber value="${ordine.totale}" pattern="0.00" /></p>
                <p>Stato: <span class="status-badge status-inlavorazione">${ordine.stato}</span></p>

                <%-- Link diretto alla pagina di riepilogo ordini del profilo utente --%>
                <a href="${pageContext.request.contextPath}/storico-ordini" class="btn btn-primary">Vai ai Tuoi Ordini</a>
            </div>
        </c:if>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>