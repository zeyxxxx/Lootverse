<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="it">
            <jsp:include page="/WEB-INF/fragments/header.jsp" />
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/checkout.css?v=2">

            <body>
                <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
                <main class="container main-content">
                    <h2>Checkout</h2>
                    <c:if test="${not empty errore}">
                        <div class="alert alert-danger">${errore}</div>
                    </c:if>
                    <c:if test="${not empty erroreForm}">
                        <div class="alert alert-danger" style="background: rgba(255, 0, 0, 0.2); border: 1px solid #ff003c; color: #ff003c; text-shadow: 0 0 5px #ff003c;">${erroreForm}</div>
                    </c:if>

                    <div class="checkout-layout">
                        <div class="checkout-form-column">
                            <h3>Spedizione e Pagamento</h3>
                            <form action="${pageContext.request.contextPath}/conferma-ordine" method="post"
                                class="form-box">
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
                                <button type="submit" class="btn btn-primary btn-submit">
                                    Conferma Ordine (€
                                    <fmt:formatNumber value="${totaleOrdine}" pattern="0.00" />)
                                </button>
                            </form>
                        </div>
                        <div class="checkout-summary-column">
                            <h3>Riepilogo</h3>
                            <ul class="summary-list">
                                <c:forEach var="item" items="${carrelloItems}">
                                    <li class="summary-item">
                                        <div class="summary-item-info">
                                            <img src="${pageContext.request.contextPath}/static/images/${not empty item.prodotto.immagine ? item.prodotto.immagine : 'default.jpg'}" alt="${item.prodotto.nome}" class="summary-item-img">
                                            <span>${item.prodotto.nome} x${item.quantita}</span>
                                        </div>
                                        <span>€ <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></span>
                                    </li>
                                </c:forEach>
                                <li>
                                    <span>Spedizione Corriere</span>
                                    <span style="color: #39ff14;">Gratis</span>
                                </li>
                            </ul>
                            <hr>
                            <h4>Totale: €
                                <fmt:formatNumber value="${totaleOrdine}" pattern="0.00" />
                            </h4>
                        </div>
                    </div>
                </main>
                <jsp:include page="/WEB-INF/fragments/footer.jsp" />
            </body>

            </html>