<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <h2>Checkout</h2>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <div class="checkout-layout">
            <div class="checkout-form-column">
                <h3>Spedizione e Pagamento</h3>
                <form action="${pageContext.request.contextPath}/checkout" method="post" class="form-box">
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
                    <h4>Carta di Credito Simulata</h4>
                    <div class="form-group">
                        <label for="numeroCarta">Numero Carta</label>
                        <input type="text" id="numeroCarta" name="numeroCarta" required maxlength="16">
                    </div>
                    <button type="submit" class="btn btn-primary btn-submit">
                        Conferma Ordine (€ <fmt:formatNumber value="${totaleCarrello}" pattern="0.00" />)
                    </button>
                </form>
            </div>
            <div class="checkout-summary-column">
                <h3>Riepilogo</h3>
                <ul class="summary-list">
                    <c:forEach var="item" items="${elementiCarrello}">
                        <li>${item.prodotto.nome} x${item.quantita} - € <fmt:formatNumber value="${item.subtotale}" pattern="0.00" /></li>
                    </c:forEach>
                </ul>
                <hr>
                <h4>Totale: € <fmt:formatNumber value="${totaleCarrello}" pattern="0.00" /></h4>
            </div>
        </div>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>