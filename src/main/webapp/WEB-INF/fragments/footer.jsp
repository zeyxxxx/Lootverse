<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer">
    <div class="footer-content">
        <p>&copy; 2026 Lootverse. Tutti i diritti riservati.</p>
        <p class="credits">Progetto Universitario TSW — Università degli Studi di Salerno</p>
    </div>
</footer>

<%-- Script JavaScript principale del progetto --%>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

<%-- Inclusione del frammento per il pannello laterale (overlay) della Wishlist --%>
<jsp:include page="/WEB-INF/fragments/listaDesideriOverlay.jsp" />
<jsp:include page="/WEB-INF/fragments/carrelloOverlay.jsp" />