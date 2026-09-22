<%-- ==============================================================================
     Pagina JSP: Carrello della Spesa (Visualizzazione Completa)
     Descrizione: Mostra la tabella dettagliata di tutti gli articoli presenti nel carrello
                  dell'utente (salvati in sessione o su DB per utenti autenticati).
                  Permette di modificare le quantità ordinate, rimuovere singoli prodotti,
                  visualizzare prezzi originali e scontati (con IVA inclusa),
                  il subtotale per riga e il totale complessivo, con accesso al Checkout.
     Inoltrata da: CarrelloServlet (GET /carrello)
     Dati in ingresso:
       - requestScope.elementiCarrello (List<ElementoCarrello>): elenco degli articoli nel carrello
       - requestScope.totaleCarrello (Double): costo complessivo ivato del carrello
       - requestScope.errore (String): eventuale messaggio di errore (es. quantità non valida)
     Form Actions:
       - POST /carrello (action=update): aggiorna la quantità per il prodotto specificato
       - POST /carrello (action=remove): elimina il prodotto selezionato dal carrello
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con viewport e tag di configurazione base --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il carrello della spesa (layout tabellare e card responsive) --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/carrello.css?v=1">

<body>
    <%-- Barra di navigazione principale del sito con indicatori dinamici --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione principale contenente la tabella carrello o il messaggio di carrello vuoto --%>
    <main class="container main-content">
        <%-- Barra superiore decorativa HUD Cyberpunk verde --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module green-neon">SYS.LOG.CART</div>
            <div class="cyber-center-text green-neon">IL TUO CARRELLO</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-line green-neon"></div>
                <div class="cyber-hud-text green-neon">V. 1.0</div>
            </div>
        </div>
        
        <%-- Alert di segnalazione errori (es. giacenza insufficiente o parametri errati) --%>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <%-- Caso 1: Nessun articolo presente nel carrello --%>
            <c:when test="${empty elementiCarrello}">
                <div class="empty-box">
                    <p>Il carrello è vuoto.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Esplora il Catalogo</a>
                </div>
            </c:when>

            <%-- Caso 2: Carrello popolato con uno o più prodotti --%>
            <c:otherwise>
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Prodotto</th>
                            <th>Prezzo Unitario</th>
                            <th>Quantità</th>
                            <th>Subtotale</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Ciclo su ciascun articolo presente nel carrello --%>
                        <c:forEach var="item" items="${elementiCarrello}">
                            <tr>
                                <%-- Colonna Prodotto: anteprima immagine e nome --%>
                                <td data-label="Prodotto">
                                    <div class="cart-product-info">
                                        <c:choose>
                                            <c:when test="${not empty item.prodotto.immagine}">
                                                <img src="${pageContext.request.contextPath}/static/images/${item.prodotto.immagine}" alt="${item.prodotto.nome}" class="cart-product-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${item.prodotto.nome}" class="cart-product-img">
                                            </c:otherwise>
                                        </c:choose>
                                        <strong>${item.prodotto.nome}</strong>
                                    </div>
                                </td>

                                <%-- Colonna Prezzo Unitario: evidenzia sconti e IVA inclusa --%>
                                <td data-label="Prezzo Unitario">
                                    <div class="cart-price-info">
                                        <div class="prices-row">
                                            <c:choose>
                                                <c:when test="${item.prodotto.sconto > 0}">
                                                    <span class="old-price">€ <fmt:formatNumber value="${item.prodotto.prezzoIvato}" pattern="0.00" /></span>
                                                    <span class="final-price">€ <fmt:formatNumber value="${item.prodotto.prezzoFinale}" pattern="0.00" /></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="final-price">€ <fmt:formatNumber value="${item.prodotto.prezzoFinale}" pattern="0.00" /></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <span class="iva-info">(IVA inclusa)</span>
                                    </div>
                                </td>

                                <%-- Colonna Quantità: form inline per aggiornare il numero di pezzi --%>
                                <td data-label="Quantità">
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="idProdotto" value="${item.prodotto.idProdotto}">
                                        <input type="number" name="quantita" value="${item.quantita}" min="1" class="qty-input">
                                        <button type="submit" class="btn btn-update">Modifica</button>
                                    </form>
                                </td>

                                <%-- Colonna Subtotale: importo complessivo per riga (prezzoFinale * quantita) --%>
                                <td data-label="Subtotale">€ <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></td>

                                <%-- Colonna Azioni: form inline per la rimozione del prodotto --%>
                                <td data-label="Azioni">
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="idProdotto" value="${item.prodotto.idProdotto}">
                                        <button type="submit" class="btn btn-remove">Rimuovi</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <%-- Barra inferiore di riepilogo totale e pulsante per procedere al checkout --%>
                <div class="cart-summary">
                    <h3>Totale Ordine: € <fmt:formatNumber value="${totaleCarrello}" pattern="0.00" /> <span class="tax-included">(IVA inclusa)</span></h3>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-checkout">Procedi al Checkout ➔</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%-- Piè di pagina standard del sito con crediti e link --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>