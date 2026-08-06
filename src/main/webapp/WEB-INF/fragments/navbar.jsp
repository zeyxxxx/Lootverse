<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar">
    <div class="nav-brand">
        <a href="${pageContext.request.contextPath}/catalogo">
            <h1>LOOT<span>VERSE</span></h1>
        </a>
    </div>

    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Cerca prodotti..." autocomplete="off">
        <div id="searchSuggestions" class="suggestions-box"></div>
    </div>

    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>

        <c:choose>
            <c:when test="${not empty sessionScope.adminLoggato}">
                <li><a href="${pageContext.request.contextPath}/admin-prodotti">Gestione Prodotti</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-ordini">Gestione Ordini</a></li>
                <li class="user-badge">Admin: ${sessionScope.adminLoggato.nome}</li>
                <li><a href="${pageContext.request.contextPath}/admin-logout" class="btn-logout">Logout Admin</a></li>
            </c:when>
            <c:when test="${not empty sessionScope.utenteLoggato}">
                <li><a href="${pageContext.request.contextPath}/carrello">Carrello</a></li>
                <li><a href="${pageContext.request.contextPath}/lista-desideri">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/storico-ordini">Miei Ordini</a></li>
                <li class="user-badge">Ciao, ${sessionScope.utenteLoggato.nome}</li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/carrello">Carrello</a></li>
                <li><a href="${pageContext.request.contextPath}/login">Accedi</a></li>
                <li><a href="${pageContext.request.contextPath}/registrazione" class="btn-highlight">Registrati</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>