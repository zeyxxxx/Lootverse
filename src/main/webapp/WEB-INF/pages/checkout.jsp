<%-- ==============================================================================
     Pagina JSP: Checkout (Spedizione e Pagamento)
     Descrizione: Schermata per la finalizzazione dell'ordine d'acquisto.
                  Raccoglie i dati anagrafici di spedizione (intestatario, indirizzo,
                  città, CAP) e i dettagli del metodo di pagamento con carta di credito
                  (numero carta, codice di sicurezza CVV, data di scadenza).
                  Affianca il modulo con una colonna di riepilogo degli articoli nel carrello,
                  i subtotali parziali, l'indicazione di spedizione gratuita e il totale dovuto.
     Inoltrata da: CheckoutServlet (GET /checkout)
     Dati in ingresso:
       - requestScope.carrelloItems (List<ElementoCarrello>): prodotti ordinati nel carrello
       - requestScope.totaleOrdine (Double): importo finale complessivo ivato
       - requestScope.errore (String): messaggio di errore generico (es. carrello vuoto)
       - requestScope.erroreForm (String): errore di validazione sui campi del form
     Form Action:
       - POST /conferma-ordine: inoltro dei dati verso la servlet di elaborazione e salvataggio
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune contenente fogli di stile globali e meta-tag --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il layout a due colonne del checkout --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/checkout.css?v=2">

<body>
    <%-- Barra di navigazione principale del sito --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Contenitore principale del processo di checkout --%>
    <main class="container main-content">
        <%-- Barra superiore decorativa HUD Cyberpunk con accenti neon verdi --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module green-neon">SYS.LOG.CHECKOUT</div>
            <div class="cyber-center-text green-neon">CHECKOUT</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-text green-neon">V. 1.0</div>
            </div>
        </div>

        <%-- Notifica per errori di sistema o eccezioni impreviste --%>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <%-- Notifica specifica per errori di validazione del form (es. dati carta o CAP non validi) --%>
        <c:if test="${not empty erroreForm}">
            <div class="alert alert-checkout-danger">${erroreForm}</div>
        </c:if>

        <%-- Layout a due colonne: a sinistra il form dati, a destra il riepilogo economico --%>
        <div class="checkout-layout">
            <%-- COLONNA SINISTRA: Modulo Dati di Spedizione e Pagamento --%>
            <div class="checkout-form-column">
                <h3>Spedizione e Pagamento</h3>
                <form action="${pageContext.request.contextPath}/conferma-ordine" method="post"
                    class="form-box">
                    
                    <%-- Dati di recapito e consegna merce --%>
                    <div class="form-group">
                        <label for="intestatario">Intestatario Spedizione</label>
                        <input type="text" id="intestatario" name="intestatario" required
                            placeholder="Nome e Cognome">
                    </div>
                    <div class="form-group">
                        <label for="indirizzo">Indirizzo</label>
                        <input type="text" id="indirizzo" name="indirizzo" required>
                    </div>
                    <div class="form-group">
                        <label for="citta">Città</label>
                        <input type="text" id="citta" name="citta" required>
                    </div>
                    <div class="form-group">
                        <label for="cap">CAP</label>
                        <input type="text" id="cap" name="cap" required maxlength="5">
                    </div>

                    <%-- Dati finanziari della carta di credito simulata --%>
                    <h4>Carta di Credito</h4>
                    <div class="form-group">
                        <label for="numeroCarta">Numero Carta</label>
                        <input type="text" id="numeroCarta" name="numeroCarta" required maxlength="16"
                            placeholder="1234567812345678">
                    </div>
                    <div class="form-group">
                        <label for="cvv">CVV</label>
                        <input type="text" id="cvv" name="cvv" required maxlength="4" placeholder="123">
                    </div>
                    <div class="form-group">
                        <label for="scadenza">Scadenza (MM/AA)</label>
                        <input type="text" id="scadenza" name="scadenza" required maxlength="5"
                            placeholder="12/25">
                    </div>

                    <%-- Pulsante di conferma definitiva con indicazione del totale economico --%>
                    <button type="submit" class="btn btn-primary btn-submit">
                        Conferma Ordine (€ <fmt:formatNumber value="${totaleOrdine}" pattern="0.00" />)
                    </button>
                </form>
            </div>

            <%-- COLONNA DESTRA: Riepilogo sintetico del carrello in acquisto --%>
            <div class="checkout-summary-column">
                <h3>Riepilogo</h3>
                <ul class="summary-list">
                    <%-- Elenco degli articoli ordinati con thumbnail, quantità e prezzo parziale --%>
                    <c:forEach var="item" items="${carrelloItems}">
                        <li class="summary-item">
                            <div class="summary-item-info">
                                <img src="${pageContext.request.contextPath}/static/images/${not empty item.prodotto.immagine ? item.prodotto.immagine : 'default.jpg'}" alt="${item.prodotto.nome}" class="summary-item-img">
                                <span>${item.prodotto.nome} x${item.quantita}</span>
                            </div>
                            <span>€ <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></span>
                        </li>
                    </c:forEach>
                    <%-- Riga costi di spedizione (offerta promozionale) --%>
                    <li>
                        <span>Spedizione Corriere</span>
                        <span class="text-free">Gratis</span>
                    </li>
                </ul>
                <hr>
                <%-- Calcolo del totale complessivo dovuto --%>
                <h4>Totale: € <fmt:formatNumber value="${totaleOrdine}" pattern="0.00" /></h4>
            </div>
        </div>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>