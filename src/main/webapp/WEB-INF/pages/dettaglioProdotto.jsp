<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/dettaglioProdotto.css?v=1">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty prodotto}">
                <div class="not-found-box">
                    <h2>Prodotto Non Trovato</h2>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Torna al Catalogo</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-detail-box">
                    <%-- 🖼️ IMMAGINE GRANDE DEL PRODOTTO --%>
                    <c:choose>
                        <c:when test="${not empty prodotto.immagine}">
                            <img src="${pageContext.request.contextPath}/static/images/${prodotto.immagine}" alt="${prodotto.nome}" class="product-detail-image">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/static/images/default.jpg" alt="${prodotto.nome}" class="product-detail-image">
                        </c:otherwise>
                    </c:choose>

                    <%-- NOME, DESCRIZIONE E SPECIFICHE --%>
                    <h2>${prodotto.nome}</h2>
                    <p class="product-desc">${prodotto.descrizione}</p>
                    
                    <ul class="product-specs">
                        <li><strong>Materiale:</strong> ${prodotto.materiale}</li>
                        <li><strong>Colore:</strong> ${prodotto.colore}</li>
                        <li><strong>Dimensione:</strong> ${prodotto.dimensione}</li>
                    </ul>
                    
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
                        <span style="font-size: 0.8rem; font-weight: normal; color: #aaa; margin-left: 10px;">(IVA inclusa)</span>
                    </h3>

                    <%-- AZIONI: CARRELLO E WISHLIST --%>
                    <div class="product-actions-group">
                        <form action="${pageContext.request.contextPath}/carrello" method="post" class="inline-form cart-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="idProdotto" value="${prodotto.idProdotto}">
                            <input type="number" name="quantita" value="1" min="1" class="qty-input">
                            <button type="submit" class="btn btn-primary">Aggiungi al Carrello</button>
                        </form>
                        
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
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>