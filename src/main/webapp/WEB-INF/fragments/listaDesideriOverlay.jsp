<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <%-- Link al CSS dell'Overlay --%>
            <link rel="stylesheet" type="text/css"
                href="${pageContext.request.contextPath}/static/css/listaDesideriOverlay.css?v=12">

            <%-- Sfondo trasparente scuro --%>
                <div id="wishlist-overlay" class="wishlist-overlay" onclick="closeWishlistDrawer()"></div>

                <%-- Pannello Laterale Drawer --%>
                    <div id="wishlist-drawer" class="wishlist-drawer">
                        <div class="drawer-header">
                            <h3 class="cyber-title">Lista Desideri</h3>
                            <button type="button" class="close-drawer-btn"
                                onclick="closeWishlistDrawer()">&times;</button>
                        </div>

                        <div id="drawer-content" class="drawer-content"></div>

                        <div class="drawer-footer">
                            <a href="${pageContext.request.contextPath}/lista-desideri"
                                class="btn btn-primary btn-block">
                                Vai alla pagina completa ➔
                            </a>
                        </div>
                    </div>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            // Intercetta l'invio del form della wishlist su tutte le pagine
                            document.addEventListener("submit", function (e) {
                                if (e.target && e.target.classList.contains("wishlist-form")) {
                                    e.preventDefault(); // Blocca il ricaricamento della pagina

                                    const form = e.target;
                                    const formData = new FormData(form);
                                    const btn = form.querySelector(".wishlist-btn");
                                    const contextPath = "${pageContext.request.contextPath}";

                                    fetch(form.getAttribute("action"), {
                                        method: "POST",
                                        headers: { "X-Requested-With": "XMLHttpRequest" },
                                        body: new URLSearchParams(formData)
                                    })
                                        .then(function (response) {
                                            if (response.status === 401 || response.redirected) {
                                                window.location.href = contextPath + "/login";
                                                return null;
                                            }
                                            if (!response.ok) {
                                                throw new Error("Errore di rete o del server: " + response.status);
                                            }
                                            return response.json();
                                        })
                                        .then(function (data) {
                                            if (!data) return;

                                            // Gestione dinamica dello stato del cuore (Pieno / Vuoto)
                                            const currentAction = formData.get("action");
                                            const actionInput = form.querySelector('input[name="action"]');

                                            if (currentAction === "add") {
                                                if (btn) btn.classList.add("in-wishlist");
                                                if (actionInput) actionInput.value = "remove";
                                                if (btn) btn.setAttribute("title", "Rimuovi dalla Wishlist");
                                            } else {
                                                if (btn) btn.classList.remove("in-wishlist");
                                                if (actionInput) actionInput.value = "add";
                                                if (btn) btn.setAttribute("title", "Aggiungi alla Wishlist");
                                            }

                                            // Renderizza la lista nel drawer e apre il pannello laterale
                                            renderWishlistDrawer(data, contextPath);
                                            openWishlistDrawer();
                                        })
                                        .catch(function (err) {
                                            console.error("Errore AJAX Wishlist:", err);
                                        });
                                }
                            });
                        });

                        function renderWishlistDrawer(products, contextPath) {
                            const container = document.getElementById("drawer-content");
                            if (!products || products.length === 0) {
                                container.innerHTML = "<p class='empty-msg'>La tua lista desideri è vuota.</p>";
                                return;
                            }

                            let html = "";
                            let subtotal = 0;

                            products.forEach(function (p) {
                                const prezzoOriginale = Number(p.prezzoIvato || p.prezzo);
                                const prezzoFinale = Number(p.prezzoFinale || p.prezzo);
                                subtotal += prezzoFinale;
                                
                                const prezzoFinaleStr = prezzoFinale.toFixed(2);
                                const imgName = p.immagine ? p.immagine : "default.jpg";

                                let priceHtml = '';
                                if (prezzoOriginale > prezzoFinale) {
                                    priceHtml = '<span class="old-price">€ ' + prezzoOriginale.toFixed(2) + '</span> ' +
                                                '<span class="drawer-item-price">€ ' + prezzoFinaleStr + ' (IVA inc.)</span>';
                                } else {
                                    priceHtml = '<span class="drawer-item-price">€ ' + prezzoFinaleStr + ' (IVA inc.)</span>';
                                }

                                html += '<div class="drawer-item">' +
                                    '<img src="' + contextPath + '/static/images/' + imgName + '" alt="' + p.nome + '">' +
                                    '<div class="drawer-item-info">' +
                                    '<h4>' + p.nome + '</h4>' +
                                    priceHtml +
                                    '</div>' +
                                    '<div class="drawer-item-actions">' +
                                    '<a href="' + contextPath + '/dettaglio-prodotto?id=' + p.idProdotto + '" class="btn-cyber btn-vedi">VEDI</a>' +
                                    '<form action="' + contextPath + '/carrello" method="post" class="cart-form">' +
                                    '<input type="hidden" name="action" value="add">' +
                                    '<input type="hidden" name="idProdotto" value="' + p.idProdotto + '">' +
                                    '<input type="hidden" name="quantita" value="1">' +
                                    '<button type="submit" class="btn-cyber btn-cart" title="Aggiungi al carrello">AL CARRELLO</button>' +
                                    '</form>' +
                                    '</div>' +
                                    '</div>';
                            });

                            html += '<div class="drawer-subtotal">' +
                                '<strong>Subtotale (' + products.length + ' articoli):</strong> ' +
                                '<span>€ ' + subtotal.toFixed(2) + '</span>' +
                                '</div>';

                            if (products.length > 0) {
                                html += '<div class="drawer-action-btn-wrap">' +
                                        '<button onclick="addAllWishlistToCart()" class="btn-cyber btn-cart">AGGIUNGI TUTTO AL CARRELLO</button>' +
                                        '</div>';
                            }

                            container.innerHTML = html;
                        }

                        window.addAllWishlistToCart = function() {
                            fetch('${pageContext.request.contextPath}/lista-desideri', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                    'X-Requested-With': 'XMLHttpRequest'
                                },
                                body: 'action=addAllToCart'
                            })
                            .then(response => {
                                if (response.ok) {
                                    closeWishlistDrawer();
                                    // Reindirizza l'utente direttamente alla pagina completa del Carrello
                                    window.location.href = '${pageContext.request.contextPath}/carrello';
                                }
                            });
                        };

                        function openWishlistDrawer() {
                            const drawer = document.getElementById("wishlist-drawer");
                            const overlay = document.getElementById("wishlist-overlay");
                            if (drawer) drawer.classList.add("open");
                            if (overlay) overlay.classList.add("active");
                        }

                        function closeWishlistDrawer() {
                            const drawer = document.getElementById("wishlist-drawer");
                            const overlay = document.getElementById("wishlist-overlay");
                            if (drawer) drawer.classList.remove("open");
                            if (overlay) overlay.classList.remove("active");
                        }
                    </script>