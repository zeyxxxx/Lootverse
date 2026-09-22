<%-- ==============================================================================
     Pagina JSP: Dettaglio Prodotto (Scheda Tecnica e Acquisto)
     Descrizione: Presenta la scheda esaustiva del singolo articolo selezionato dal catalogo.
                  Visualizza l'immagine ad alta risoluzione del prodotto, la descrizione estesa,
                  le specifiche fisiche (materiale costruttivo, colorazione, dimensioni),
                  il calcolo del prezzo finale con evidenza dell'eventuale sconto percentuale
                  e specifica dell'IVA inclusa.
                  Fornisce il selettore numerico della quantità e i form di aggiunta rapida
                  sia al carrello (gestito anche via AJAX dal carrelloOverlay) sia alla Lista Desideri.
     Inoltrata da: DettaglioProdottoServlet (GET /dettaglio-prodotto?id=...)
     Dati in ingresso:
       - requestScope.prodotto (Prodotto): bean del prodotto con tutte le proprietà valorizzate
       - requestScope.errore (String): eventuale messaggio di errore (es. ID non valido)
     Form Actions:
       - POST /carrello (action=add): aggiunge la quantità indicata al carrello
       - POST /lista-desideri (action=add): aggiunge il prodotto alla wishlist
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con viewport e tag di configurazione base --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per la scheda prodotto dettagliata --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/dettaglioProdotto.css?v=1">

<body>
    <%-- Barra di navigazione principale del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione principale contenente il box scheda prodotto --%>
    <main class="container main-content">
        <%-- Notifica di errore se il prodotto non esiste o si sono verificati problemi --%>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <%-- Caso di prodotto inesistente o non trovato sul database --%>
            <c:when test="${empty prodotto}">
                <div class="not-found-box">
                    <h2>Prodotto Non Trovato</h2>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Torna al Catalogo</a>
                </div>
            </c:when>

            <%-- Scheda completa del prodotto caricato con successo --%>
            <c:otherwise>
                <%-- Elemento grafico HUD Cyberpunk decorativo --%>
                <div class="cyber-divider-wrapper">
                    <div class="cyber-divider"></div>
                    <div class="cyber-left-module">SYS.LOG.DETAILS</div>
                    <div class="cyber-center-text">DETTAGLI PRODOTTO</div>
                    <div class="cyber-right-hud">
                        <div class="cyber-hud-line"></div>
                        <div class="cyber-hud-line"></div>
                        <div class="cyber-hud-line"></div>
                        <div class="cyber-hud-text">V. 1.0</div>
                    </div>
                </div>
                
                <div class="product-detail-box">
                    <%-- Immagine principale del prodotto o segnaposto predefinito --%>
                    <c:choose>
                        <c:when test="${not empty prodotto.immagine}">
                            <img src="${pageContext.request.contextPath}/static/images/${prodotto.immagine}" alt="${prodotto.nome}" class="product-detail-image">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${prodotto.nome}" class="product-detail-image">
                        </c:otherwise>
                    </c:choose>

                    <%-- Intestazione con nome dell'articolo e descrizione narrativa --%>
                    <h2>${prodotto.nome}</h2>
                    <p class="product-desc">${prodotto.descrizione}</p>
                    
                    <%-- Elenco puntato delle specifiche fisiche del manufatto --%>
                    <ul class="product-specs">
                        <li><strong>Materiale:</strong> ${prodotto.materiale}</li>
                        <li><strong>Colore:</strong> ${prodotto.colore}</li>
                        <li><strong>Dimensione:</strong> ${prodotto.dimensione}</li>
                    </ul>
                    
                    <%-- Visualizzazione del prezzo d'acquisto con calcolo IVA ed eventuale sconto --%>
                    <h3 class="product-price">
                        Prezzo: 
                        <c:choose>
                            <c:when test="${prodotto.sconto > 0}">
                                <span class="old-price">€ <fmt:formatNumber value="${prodotto.prezzoIvato}" pattern="0.00" /></span>
                                € <fmt:formatNumber value="${prodotto.prezzoFinale}" pattern="0.00" />
                            </c:when>
                            <c:otherwise>
                                € <fmt:formatNumber value="${prodotto.prezzoFinale}" pattern="0.00" />
                            </c:otherwise>
                        </c:choose>
                        <span class="tax-included">(IVA inclusa)</span>
                    </h3>

                    <%-- Gruppo di azioni rapide: selezione quantità, acquisto carrello e salvataggio wishlist --%>
                    <div class="product-actions-group">
                        <%-- Form per l'aggiunta al carrello con classe 'cart-form' per supporto AJAX --%>
                        <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form cart-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">
                            <input type="number" name="quantita" value="1" min="1" class="qty-input">
                            <button type="submit" class="btn btn-primary">Aggiungi al Carrello</button>
                        </form>
                        
                        <%-- Form per l'inserimento rapido nella lista dei desideri --%>
                        <form action="${pageContext.request.contextPath}/lista-desideri" method="post" class="inline-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">
                            <button type="submit" class="btn btn-secondary">Wishlist</button>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>