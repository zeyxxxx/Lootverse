<%-- ==============================================================================
     Pagina JSP: Dettaglio Ordine (Fattura e Voci d'Acquisto)
     Descrizione: Mostra la composizione dettagliata di un ordine specifico:
                  data di emissione, stato di avanzamento della spedizione, elenco degli articoli
                  con quantità, prezzo storico unitario applicato al momento dell'acquisto,
                  subtotale di riga, importo complessivo dell'ordine e funzionalità di stampa/PDF.
                  Supporta sia la visualizzazione da parte dell'utente ordinante sia da parte
                  dell'amministratore (con link dinamico di ritorno allo storico appropriato).
     Inoltrata da: DettaglioOrdineServlet (GET /dettaglio-ordine?id=...)
     Dati in ingresso:
       - requestScope.ordine (Ordine): bean dell'ordine selezionato
       - requestScope.dettagliItems (List<DettaglioOrdineItem>): righe d'ordine con associazioni prodotto
       - requestScope.isAdmin (Boolean): flag che indica se l'utente connesso è un amministratore
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con meta tag e stili globali --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il dettaglio ordine e le regole di stampa PDF --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/dettaglioOrdine.css">

<body>
    <%-- Barra di navigazione principale del sito --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione principale contenente la scheda d'ordine --%>
    <main class="container main-content">
        <%-- Barra superiore decorativa HUD Cyberpunk (nascosta in fase di stampa) --%>
        <div class="cyber-divider-wrapper hide-on-print">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module">SYS.LOG.ORDER</div>
            <div class="cyber-center-text">DETTAGLIO ORDINE</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-text">V. 1.0</div>
            </div>
        </div>

        <%-- Metadati dell'ordine: data e badge di stato --%>
        <div class="order-header-info">
            <h2 class="print-only">Dettagli del tuo Ordine</h2>
            <div class="cyber-info-container">
                <p class="cyber-info-line"><span class="cyber-label">DATA:</span> <span class="cyber-value">${ordine.data}</span></p>
                <p class="cyber-info-line hide-on-print"><span class="cyber-label">STATO:</span> <span class="status-badge status-${ordine.stato.replaceAll('\\s+', '').toLowerCase()}">${ordine.stato}</span></p>
            </div>
        </div>

        <%-- Elenco dettagliato delle voci di prodotto acquistate --%>
        <div class="product-list-container">
            <c:choose>
                <%-- Caso limite di ordine senza righe associate --%>
                <c:when test="${empty dettagliItems}">
                    <p class="error-text">Nessun prodotto trovato per questo ordine.</p>
                </c:when>

                <%-- Ciclo sulle voci del dettaglio ordine con riferimento al prodotto --%>
                <c:otherwise>
                    <c:forEach var="item" items="${dettagliItems}">
                        <div class="product-card">
                            <%-- Miniatura del prodotto acquistato --%>
                            <div class="product-img-wrapper">
                                <c:choose>
                                    <c:when test="${not empty item.prodotto.immagine}">
                                        <img src="${pageContext.request.contextPath}/static/images/${item.prodotto.immagine}" alt="${item.prodotto.nome}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${item.prodotto.nome}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <%-- Informazioni quantitative e contabili della riga --%>
                            <div class="product-info">
                                <h3>${item.prodotto.nome}</h3>
                                <p class="qty">Quantità: <span>${item.dettaglio.quantita}</span></p>
                                <p class="price">Prezzo pagato cad.: € <fmt:formatNumber value="${item.dettaglio.prezzo}" pattern="0.00" /></p>
                                <p class="subtotal">Subtotale riga: € <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></p>
                            </div>
                            <%-- Collegamento per visualizzare la scheda attuale del prodotto --%>
                            <div class="product-action">
                                <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${item.prodotto.idProdotto}" class="btn btn-primary">Vedi Prodotto</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- Riepilogo finale con totale complessivo e pulsanti operativi (stampa fattura / ritorno) --%>
        <div class="order-total-summary">
            <h3>Totale Ordine: <span class="total-price">€ <fmt:formatNumber value="${ordine.totale}" pattern="0.00" /></span></h3>
            <%-- Innesca la stampa del browser o il salvataggio in formato PDF --%>
            <button onclick="window.print()" class="btn btn-primary btn-print">🖨️ Stampa Fattura / Salva PDF</button>
            <%-- Ritorno contestuale allo storico ordini (se admin va al pannello gestione, altrimenti storico cliente) --%>
            <a href="${pageContext.request.contextPath}${isAdmin ? '/admin-ordini' : '/storico-ordini'}" class="btn btn-secondary">⬅ Torna allo Storico</a>
        </div>
    </main>

    <%-- Piè di pagina comune del portale --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>
