<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/storicoOrdini.css">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container main-content">
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module blue-neon">SYS.LOG.ORDERS</div>
            <div class="cyber-center-text blue-neon">I TUOI ORDINI</div>
            <div class="cyber-right-hud">
                <div class="cyber-hud-line blue-neon"></div>
                <div class="cyber-hud-line blue-neon"></div>
                <div class="cyber-hud-line blue-neon"></div>
                <div class="cyber-hud-text blue-neon">V. 1.0</div>
            </div>
        </div>
        
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty ordini}">
                <div class="empty-box">
                    <p>Non hai ancora effettuato ordini.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Vai al Catalogo</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="ordini-container">
                    <c:forEach var="ordine" items="${ordini}" varStatus="loop">
                        <div class="ordine-card">
                            <div class="ordine-header">
                                <h3>Ordine #${fn:length(ordini) - loop.index}</h3>
                                <span class="status-badge status-${ordine.stato.replaceAll('\\s+', '').toLowerCase()}">${ordine.stato}</span>
                            </div>
                            <div class="ordine-body">
                                <p><strong>Data:</strong> ${ordine.data}</p>
                                <p><strong>Totale:</strong> € <fmt:formatNumber value="${ordine.totale}" pattern="0.00" /></p>
                                <a href="${pageContext.request.contextPath}/dettaglio-ordine?id=${ordine.idOrdine}" class="btn btn-secondary">Visualizza Prodotti ➔</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>