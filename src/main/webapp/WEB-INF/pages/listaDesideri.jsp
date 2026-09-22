<%-- ==============================================================================
     Pagina JSP: Lista Desideri (Visualizzazione Completa della Wishlist)
     Descrizione: Schermata estesa della lista desideri dell'utente loggato.
                  Mostra la griglia di tutte le card dei prodotti salvati tra i preferiti,
                  con thumbnail, nome, prezzo ivato, indicazione di eventuali sconti,
                  pulsante rapido per aggiungere l'articolo al carrello, link alla scheda di dettaglio
                  e form per rimuovere il singolo articolo dalla lista desideri.
     Inoltrata da: ListaDesideriServlet (GET /lista-desideri)
     Dati in ingresso:
       - requestScope.prodottiWishlist (List<Prodotto>): collezione dei prodotti presenti in wishlist
     Form Actions:
       - POST /carrello (action=add): sposta/aggiunge l'articolo selezionato nel carrello
       - POST /lista-desideri (action=remove): elimina il prodotto dalla lista dei desideri
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con meta tag e risorse globali --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per la pagina della lista desideri --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/listaDesideri.css?v=1">

<body>
    <%-- Barra di navigazione principale del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione principale contenente la griglia della wishlist o il box di lista vuota --%>
    <main class="container main-content">
        <%-- Barra superiore decorativa HUD Cyberpunk con accenti rosa neon --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module pink-neon">SYS.LOG.WISHLIST</div>
            <div class="cyber-center-text pink-neon">LA TUA WISHLIST</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line pink-neon"></div>
                <div class="cyber-hud-line pink-neon"></div>
                <div class="cyber-hud-line pink-neon"></div>
                <div class="cyber-hud-text pink-neon">V. 1.0</div>
            </div>
        </div>

        <c:choose>
            <%-- Caso 1: La lista desideri è vuota --%>
            <c:when test="${empty prodottiWishlist}">
                <div class="empty-box">
                    <p>La tua Wishlist è vuota.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Esplora il Catalogo</a>
                </div>
            </c:when>

            <%-- Caso 2: Sono presenti uno o più articoli nella lista desideri --%>
            <c:otherwise>
                <div class="wishlist-grid">
                    <%-- Iterazione sui prodotti salvati nella lista --%>
                    <c:forEach var="p" items="${prodottiWishlist}">
                        <div class="wishlist-card">
                            <%-- Miniatura del prodotto con fallback su default.jpg --%>
                            <c:choose>
                                <c:when test="${not empty p.immagine}">
                                    <img src="${pageContext.request.contextPath}/static/images/${p.immagine}" alt="${p.nome}" class="wishlist-card-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${p.nome}" class="wishlist-card-img">
                                </c:otherwise>
                            </c:choose>

                            <h4>${p.nome}</h4>
                            <%-- Prezzo corrente con eventuale prezzo originale barrato --%>
                            <c:choose>
                                <c:when test="${p.sconto > 0}">
                                    <p class="product-price">
                                        <span class="old-price">€ <fmt:formatNumber value="${p.prezzoIvato}" pattern="0.00" /></span> 
                                        € <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" />
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="product-price">€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></p>
                                </c:otherwise>
                            </c:choose>
                            <p class="iva-label">(IVA inclusa)</p>

                            <%-- Gruppo di azioni rapide: aggiunta al carrello, scheda dettaglio e cancellazione --%>
                            <div class="wishlist-actions">
                                <%-- Form di aggiunta al carrello con classe 'cart-form' per intercettazione AJAX --%>
                                <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form cart-form">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                    <input type="hidden" name="quantita" value="1">
                                    <button type="submit" class="btn btn-primary">Aggiungi 🛒</button>
                                </form>

                                <%-- Link alla scheda prodotto completa --%>
                                <a href="${pageContext.request.contextPath}/dettaglio-prodotto?id=${p.idProdotto}" class="btn btn-secondary">Dettagli</a>

                                <%-- Form per la rimozione del prodotto dalla lista desideri --%>
                                <form action="${pageContext.request.contextPath}/lista-desideri" method="post" class="inline-form">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                    <button type="submit" class="btn-remove-wishlist">Rimuovi</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>