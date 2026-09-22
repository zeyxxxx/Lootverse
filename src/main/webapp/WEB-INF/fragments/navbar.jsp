<%--
 ==============================================================================
 Frammento JSP: /WEB-INF/fragments/navbar.jsp
 Descrizione: Barra di navigazione principale (sticky header) visibile in tutte le pagine.
              Fornisce:
              1. Marchio aziendale con redirect alla Home (/index)
              2. Barra di ricerca prodotti con autocompletamento dinamico AJAX (/ricerca-suggerimenti)
              3. Voci di menu contestuali in base all'autenticazione:
                 - Ospite: Carrello, Catalogo, Accedi, Registrati
                 - Utente loggato: Carrello con badge contatore, Wishlist, Catalogo, Miei Ordini, Logout
                 - Amministratore: Catalogo, Gestione Prodotti, Gestione Ordini, Logout Admin
              4. Menu a scomparsa responsive (hamburger) per dispositivi mobili.
 Dati in sessione:
   - sessionScope.adminLoggato: bean AdminBean per l'accesso alle funzionalita gestionali
   - sessionScope.utenteLoggato: bean UtenteBean per l'area cliente
   - sessionScope.cartBadgeCount: contatore numerico degli articoli presenti nel carrello
 ==============================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar">
    <%-- Testata della Navbar: Brand e pulsante menu mobile --%>
    <div class="navbar-header">
        <div class="nav-brand">
            <%-- Logo dell'applicazione con collegamento alla Home Page --%>
            <a href="${pageContext.request.contextPath}/index">
                <h1>LOOT<span>VERSE</span></h1>
            </a>
        </div>
        
        <%-- Pulsante hamburger per dispositivi mobili (mostrato solo sotto i 1200px) --%>
        <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Apri menu">
            <span class="material-symbols-outlined">menu</span>
        </button>
    </div>

    <%-- Sezione centrale e destra della Navbar: ricerca e collegamenti --%>
    <div class="nav-menu" id="navMenu">
        <%-- Barra di ricerca con suggerimenti asincroni AJAX in tempo reale --%>
        <div class="search-wrapper">
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/catalogo" method="GET">
                    <input type="text" id="searchInput" name="searchQuery" placeholder="Cerca prodotti..."
                        autocomplete="off" value="${searchQuery}">
                </form>
            </div>
            <%-- Box a tendina popolato dinamicamente da JavaScript con i risultati della ricerca --%>
            <div id="searchSuggestions" class="suggestions-box"></div>
        </div>

        <%-- Voci di navigazione e autenticazione differenziate per ruolo utente --%>
        <ul class="nav-links">
            <c:choose>
                <%-- CASO 1: Amministratore autenticato --%>
                <c:when test="${not empty sessionScope.adminLoggato}">
                    <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin-prodotti">Gestione Prodotti</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin-ordini">Gestione Ordini</a></li>
                    <li class="user-badge">Admin: ${sessionScope.adminLoggato.nome}</li>
                    <li><a href="${pageContext.request.contextPath}/admin-logout" class="btn-logout">Logout Admin</a></li>
                </c:when>

                <%-- CASO 2: Utente acquirente autenticato --%>
                <c:when test="${not empty sessionScope.utenteLoggato}">
                    <%-- Icona Carrello con badge del conteggio articoli --%>
                    <li>
                        <a href="${pageContext.request.contextPath}/carrello" class="cart-icon-container">
                            <span class="material-symbols-outlined">shopping_cart</span>
                            <c:if test="${not empty sessionScope.cartBadgeCount and sessionScope.cartBadgeCount gt 0}">
                                <span class="cart-badge">${sessionScope.cartBadgeCount}</span>
                            </c:if>
                        </a>
                    </li>
                    <%-- Icona Lista Desideri --%>
                    <li>
                        <a href="${pageContext.request.contextPath}/lista-desideri">
                            <span class="material-symbols-outlined">favorite</span>
                        </a>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
                    <li><a href="${pageContext.request.contextPath}/storico-ordini">Miei Ordini</a></li>
                    <li class="user-badge">Ciao, ${sessionScope.utenteLoggato.nome}</li>
                    <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
                </c:when>

                <%-- CASO 3: Utente ospite non autenticato --%>
                <c:otherwise>
                    <%-- Carrello visitatore --%>
                    <li>
                        <a href="${pageContext.request.contextPath}/carrello" class="cart-icon-container">
                            <span class="material-symbols-outlined">shopping_cart</span>
                            <c:if test="${not empty sessionScope.cartBadgeCount and sessionScope.cartBadgeCount gt 0}">
                                <span class="cart-badge">${sessionScope.cartBadgeCount}</span>
                            </c:if>
                        </a>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Accedi</a></li>
                    <li><a href="${pageContext.request.contextPath}/registrazione" class="btn-highlight">Registrati</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<%-- Logica JavaScript per il menu mobile responsive e i suggerimenti di ricerca AJAX --%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchInput");
        const suggestionsBox = document.getElementById("searchSuggestions");
        const mobileMenuBtn = document.getElementById("mobileMenuBtn");
        const navMenu = document.getElementById("navMenu");

        // Gestione apertura/chiusura del menu mobile con commutazione icona menu/close
        if (mobileMenuBtn && navMenu) {
            mobileMenuBtn.addEventListener("click", function() {
                navMenu.classList.toggle("active");
                const icon = this.querySelector(".material-symbols-outlined");
                if (navMenu.classList.contains("active")) {
                    icon.textContent = "close";
                } else {
                    icon.textContent = "menu";
                }
            });
        }

        // Ricerca asincrona AJAX con debounce di 300ms alla digitazione
        if (searchInput && suggestionsBox) {
            let timeout = null;
            searchInput.addEventListener("input", function () {
                clearTimeout(timeout);
                const query = searchInput.value.trim();
                if (query.length < 2) {
                    suggestionsBox.style.display = "none";
                    suggestionsBox.innerHTML = "";
                    return;
                }

                timeout = setTimeout(() => {
                    fetch("${pageContext.request.contextPath}/ricerca-suggerimenti?q=" + encodeURIComponent(query))
                        .then(response => response.json())
                        .then(data => {
                            suggestionsBox.innerHTML = "";
                            if (data.length === 0) {
                                const noResult = document.createElement("div");
                                noResult.className = "suggestion-item";
                                noResult.style.padding = "10px 15px";
                                noResult.style.color = "var(--text-muted)";
                                noResult.textContent = "Nessun risultato";
                                suggestionsBox.appendChild(noResult);
                            } else {
                                data.forEach(item => {
                                    const suggestion = document.createElement("a");
                                    suggestion.className = "suggestion-item";
                                    suggestion.href = "${pageContext.request.contextPath}/dettaglio-prodotto?id=" + item.id;
                                    suggestion.style.display = "flex";
                                    suggestion.style.justifyContent = "space-between";
                                    suggestion.style.padding = "10px 15px";
                                    suggestion.style.color = "var(--text-light)";
                                    suggestion.style.textDecoration = "none";
                                    suggestion.style.borderBottom = "1px solid #222";

                                    suggestion.addEventListener("mouseover", function () {
                                        this.style.backgroundColor = "rgba(0, 240, 255, 0.1)";
                                        this.style.color = "var(--accent-color)";
                                    });
                                    suggestion.addEventListener("mouseout", function () {
                                        this.style.backgroundColor = "transparent";
                                        this.style.color = "var(--text-light)";
                                    });

                                    const nameSpan = document.createElement("span");
                                    nameSpan.textContent = item.nome;

                                    const priceSpan = document.createElement("strong");
                                    priceSpan.textContent = "€" + parseFloat(item.prezzo).toFixed(2);
                                    priceSpan.style.color = "var(--accent-color)";

                                    suggestion.appendChild(nameSpan);
                                    suggestion.appendChild(priceSpan);
                                    suggestionsBox.appendChild(suggestion);
                                });
                            }
                            suggestionsBox.style.display = "block";
                        })
                        .catch(error => {
                            console.error("Errore AJAX suggerimenti:", error);
                        });
                }, 300);
            });

            // Chiusura del box suggerimenti al clic all'esterno
            document.addEventListener("click", function (event) {
                if (!searchInput.contains(event.target) && !suggestionsBox.contains(event.target)) {
                    suggestionsBox.style.display = "none";
                }
            });

            // Riapertura del box suggerimenti al focus se contiene gia del testo cercato
            searchInput.addEventListener("focus", function () {
                if (searchInput.value.trim().length >= 2 && suggestionsBox.innerHTML !== "") {
                    suggestionsBox.style.display = "block";
                }
            });
        }
    });
</script>