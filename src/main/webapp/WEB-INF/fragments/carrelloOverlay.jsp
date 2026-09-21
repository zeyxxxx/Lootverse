<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <%-- Link al CSS dell'Overlay --%>
            <link rel="stylesheet" type="text/css"
                href="${pageContext.request.contextPath}/static/css/carrelloOverlay.css?v=12">

            <%-- Sfondo trasparente scuro --%>
                <div id="cart-overlay" class="cart-overlay" onclick="closecartDrawer()"></div>

                <%-- Pannello Laterale Drawer --%>
                    <div id="cart-drawer" class="cart-drawer">
                        <div class="drawer-header">
                            <h3 class="cyber-title">Carrello</h3>
                            <button type="button" class="close-drawer-btn"
                                onclick="closecartDrawer()">&times;</button>
                        </div>

                        <div id="cart-drawer-content" class="drawer-content"></div>

                        <div class="drawer-footer">
                            <a href="${pageContext.request.contextPath}/carrello"
                                class="btn btn-primary btn-block">
                                Vai alla pagina completa ➔
                            </a>
                        </div>
                    </div>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            // Intercetta l'invio del form della cart su tutte le pagine
                            document.addEventListener("submit", function (e) {
                                if (e.target && e.target.classList.contains("cart-form")) {
                                    e.preventDefault(); // Blocca il ricaricamento della pagina

                                    const form = e.target;
                                    const formData = new FormData(form);
                                    const btn = form.querySelector(".cart-btn");
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

                                            // Rimosso toggle del cuore, il carrello non funziona come la wishlist.
                                            // Ogni click aggiunge quantità.

                                            // Aggiorna visivamente il badge nella navbar
                                            const badge = document.querySelector(".cart-badge");
                                            if (badge) {
                                                let totalItems = 0;
                                                data.forEach(p => totalItems += (p.quantita || 1));
                                                badge.textContent = totalItems;
                                            } else {
                                                // Se non c'è il badge, potremmo crearlo, o semplicemente ricaricare la pagina.
                                                // Ma il carrello overlay si apre, quindi va bene lo stesso.
                                            }

                                            // Renderizza la lista nel drawer e apre il pannello laterale
                                            rendercartDrawer(data, contextPath);
                                            opencartDrawer();
                                        })
                                        .catch(function (err) {
                                            console.error("Errore AJAX cart:", err);
                                        });
                                }
                            });
                        });

                        function rendercartDrawer(products, contextPath) {
                            const container = document.getElementById("cart-drawer-content");
                            if (!products || products.length === 0) {
                                container.innerHTML = "<p class='empty-msg'>Il tuo carrello è vuoto.</p>";
                                return;
                            }

                            let html = "";
                            let subtotal = 0;

                            products.forEach(function (p) {
                                const prezzoOriginale = Number(p.prezzoIvato || p.prezzo);
                                const prezzoFinale = Number(p.prezzoFinale || p.prezzo);
                                const quantita = Number(p.quantita || 1);
                                subtotal += (prezzoFinale * quantita);
                                
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
                                    '<h4>' + p.nome + ' (x' + quantita + ')</h4>' +
                                    priceHtml +
                                    '</div>' +
                                    '<div class="drawer-item-actions">' +
                                    '<a href="' + contextPath + '/dettaglio-prodotto?id=' + p.idProdotto + '" class="btn-cyber btn-vedi">VEDI</a>' +
                                    '<form action="' + contextPath + '/carrello" method="post" class="cart-form">' +
                                    '<input type="hidden" name="action" value="remove">' +
                                    '<input type="hidden" name="idProdotto" value="' + p.idProdotto + '">' +
                                    '<input type="hidden" name="quantita" value="1">' +
                                    '<button type="submit" class="btn-cyber btn-cart" title="RIMUOVI">RIMUOVI</button>' +
                                    '</form>' +
                                    '</div>' +
                                    '</div>';
                            });

                            html += '<div class="drawer-subtotal">' +
                                '<strong>Totale:</strong> ' +
                                '<span>€ ' + subtotal.toFixed(2) + '</span>' +
                                '</div>';

                            if (products.length > 0) {
                                html += '<div class="drawer-action-btn-wrap">' +
                                        '<button onclick="checkoutCart()" class="btn-cyber btn-cart">PROCEDI ALL\'ACQUISTO</button>' +
                                        '</div>';
                            }

                            container.innerHTML = html;
                        }

                        window.checkoutCart = function() {
                            window.location.href = "${pageContext.request.contextPath}/carrello";
                        };

                        function opencartDrawer() {
                            const drawer = document.getElementById("cart-drawer");
                            const overlay = document.getElementById("cart-overlay");
                            if (drawer) drawer.classList.add("open");
                            if (overlay) overlay.classList.add("active");
                        }

                        function closecartDrawer() {
                            const drawer = document.getElementById("cart-drawer");
                            const overlay = document.getElementById("cart-overlay");
                            if (drawer) drawer.classList.remove("open");
                            if (overlay) overlay.classList.remove("active");
                        }
                    </script>
