<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <nav class="navbar">
            <div class="navbar-header">
                <div class="nav-brand">
                    <%-- Il logo riporta alla Home (/index) --%>
                        <a href="${pageContext.request.contextPath}/index">
                            <h1>LOOT<span>VERSE</span></h1>
                        </a>
                </div>
                
                <%-- Mobile Hamburger Menu Button --%>
                <button class="mobile-menu-btn" id="mobileMenuBtn">
                    <span class="material-symbols-outlined">menu</span>
                </button>
            </div>

            <div class="nav-menu" id="navMenu">
                <div class="search-wrapper">
                    <div class="search-container">
                        <form action="${pageContext.request.contextPath}/catalogo" method="GET">
                            <input type="text" id="searchInput" name="searchQuery" placeholder="Cerca prodotti..."
                                autocomplete="off" value="${searchQuery}">
                        </form>
                    </div>
                    <div id="searchSuggestions" class="suggestions-box"></div>
                </div>

                <ul class="nav-links">
                    <%-- Link espliciti in Navbar --%>
                        <c:choose>
                            <c:when test="${not empty sessionScope.adminLoggato}">
                                <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin-prodotti">Gestione Prodotti</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin-ordini">Gestione Ordini</a></li>
                                <li class="user-badge">Admin: ${sessionScope.adminLoggato.nome}</li>
                                <li><a href="${pageContext.request.contextPath}/admin-logout" class="btn-logout">Logout
                                        Admin</a></li>
                            </c:when>
                            <c:when test="${not empty sessionScope.utenteLoggato}">
                                <li><a href="${pageContext.request.contextPath}/carrello" class="cart-icon-container">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                        <c:if
                                            test="${not empty sessionScope.cartBadgeCount and sessionScope.cartBadgeCount gt 0}">
                                            <span class="cart-badge">${sessionScope.cartBadgeCount}</span>
                                        </c:if>
                                    </a></li>
                                <li><a href="${pageContext.request.contextPath}/lista-desideri"> <span
                                            class="material-symbols-outlined">favorite</span> </a></li>
                                <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
                                <li><a href="${pageContext.request.contextPath}/storico-ordini">Miei Ordini</a></li>
                                <li class="user-badge">Ciao, ${sessionScope.utenteLoggato.nome}</li>
                                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/carrello" class="cart-icon-container">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                        <c:if
                                            test="${not empty sessionScope.cartBadgeCount and sessionScope.cartBadgeCount gt 0}">
                                            <span class="cart-badge">${sessionScope.cartBadgeCount}</span>
                                        </c:if>
                                    </a></li>
                                <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
                                <li><a href="${pageContext.request.contextPath}/login">Accedi</a></li>
                                <li><a href="${pageContext.request.contextPath}/registrazione"
                                        class="btn-highlight">Registrati</a></li>
                            </c:otherwise>
                        </c:choose>
                </ul>
            </div>
        </nav>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const searchInput = document.getElementById("searchInput");
                const suggestionsBox = document.getElementById("searchSuggestions");
                const mobileMenuBtn = document.getElementById("mobileMenuBtn");
                const navMenu = document.getElementById("navMenu");

                // Toggle Mobile Menu
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

                    // Hide suggestions when clicking outside
                    document.addEventListener("click", function (event) {
                        if (!searchInput.contains(event.target) && !suggestionsBox.contains(event.target)) {
                            suggestionsBox.style.display = "none";
                        }
                    });

                    // Show suggestions when clicking back in input if there's text
                    searchInput.addEventListener("focus", function () {
                        if (searchInput.value.trim().length >= 2 && suggestionsBox.innerHTML !== "") {
                            suggestionsBox.style.display = "block";
                        }
                    });
                }
            });
        </script>