<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.utente.UtenteBean"%>
<%@ page import="model.admin.AdminBean"%>

<%
    UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
    AdminBean adminLoggato = (AdminBean) session.getAttribute("adminLoggato");
%>

<nav class="navbar">
    <div class="nav-brand">
        <a href="<%= request.getContextPath() %>/catalogo">
            <h1>LOOT<span>VERSE</span></h1>
        </a>
    </div>

    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Cerca loot, armi, accessori..." autocomplete="off">
        <div id="searchSuggestions" class="suggestions-box"></div>
    </div>

    <ul class="nav-links">
        <li><a href="<%= request.getContextPath() %>/catalogo">Catalogo</a></li>

        <% if (adminLoggato != null) { %>
            <li><a href="<%= request.getContextPath() %>/admin-prodotti">Gestione Prodotti</a></li>
            <li><a href="<%= request.getContextPath() %>/admin-ordini">Gestione Ordini</a></li>
            <li class="user-badge">Admin: <%= adminLoggato.getNome() %></li>
            <li><a href="<%= request.getContextPath() %>/admin-logout" class="btn-logout">Logout Admin</a></li>

        <% } else if (utenteLoggato != null) { %>
            <li><a href="<%= request.getContextPath() %>/carrello">Carrello</a></li>
            <li><a href="<%= request.getContextPath() %>/lista-desideri">Wishlist</a></li>
            <li><a href="<%= request.getContextPath() %>/storico-ordini">Miei Ordini</a></li>
            <li class="user-badge">Ciao, <%= utenteLoggato.getNome() %></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a></li>

        <% } else { %>
            <li><a href="<%= request.getContextPath() %>/carrello">Carrello 🛒</a></li>
            <li><a href="<%= request.getContextPath() %>/login">Accedi</a></li>
            <li><a href="<%= request.getContextPath() %>/registrazione" class="btn-highlight">Registrati</a></li>
        <% } %>
    </ul>
</nav>