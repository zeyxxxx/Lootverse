<%-- ==============================================================================
     Pagina JSP: Conferma Eliminazione Prodotto (Admin)
     Descrizione: Schermata modale/intermedia di sicurezza per confermare
                  l'eliminazione permanente di un articolo dal catalogo prodotti.
     Inoltrata da: GestioneProdottiServlet (POST/GET /admin-prodotti)
     Dati in ingresso:
       - requestScope.prodotto (Prodotto): il bean del prodotto selezionato per la rimozione
     Form Action:
       - POST /admin-prodotti: invia l'azione 'delete' con l'identificativo del prodotto
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<body>
    <%-- Barra di navigazione principale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Contenuto principale centrato per la richiesta di conferma --%>
    <main class="container main-content centered-content">
        <h2>Sei sicuro di voler eliminare il prodotto?</h2>
        <p>Prodotto: <strong>${prodotto.nome}</strong></p>

        <%-- Form per l'invio della conferma di rimozione o cancellazione operazione --%>
        <form action="${pageContext.request.contextPath}/admin-prodotti" method="post" class="confirm-form">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">
            <button type="submit" class="btn btn-danger">Sì, Elimina</button>
            <a href="${pageContext.request.contextPath}/admin-prodotti" class="btn btn-secondary">Annulla</a>
        </form>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>