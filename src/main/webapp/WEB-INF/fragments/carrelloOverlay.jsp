<%-- ==============================================================================
     Frammento JSP: Carrello Overlay (Drawer Laterale)
     Descrizione: Fornisce l'interfaccia a cassetto laterale (drawer) e lo sfondo oscurato
                  per la visualizzazione e gestione rapida del carrello senza ricaricare la pagina.
                  Include gli script JavaScript per intercettare le sottomissioni AJAX dei form
                  di aggiunta/rimozione carrello, l'aggiornamento dinamico del badge numerico,
                  il calcolo del subtotale e il rendering del contenuto del drawer.
     Uso: Incluso in fondo alle pagine principali del portale (es. index, catalogo, dettaglio).
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <%-- Foglio di stile dedicato per l'animazione e il layout dell'overlay carrello --%>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/static/css/carrelloOverlay.css?v=12">

    <%-- Sfondo oscurato (Backdrop): cliccando sull'overlay scuro il drawer viene chiuso --%>
    <div id="cart-overlay" class="cart-overlay" onclick="closecartDrawer()"></div>

    <%-- Pannello Laterale a Comparsa (Drawer) --%>
    <div id="cart-drawer" class="cart-drawer">
        <%-- Testata del Drawer con titolo e pulsante di chiusura --%>
        <div class="drawer-header">
            <h3 class="cyber-title">Carrello</h3>
            <button type="button" class="close-drawer-btn"
                onclick="closecartDrawer()" title="Chiudi carrello">&times;</button>
        </div>

        <%-- Contenitore dinamico popolato via JavaScript con gli articoli nel carrello --%>
        <div id="cart-drawer-content" class="drawer-content"></div>

        <%-- Piè di pagina del Drawer con link diretto alla pagina di riepilogo completo --%>
        <div class="drawer-footer">
            <a href="${pageContext.request.contextPath}/carrello"
                class="btn btn-primary btn-block">
                Vai alla pagina completa ➔
            </a>
        </div>
    </div>

    <%-- Logica JavaScript per gestione AJAX ed interattività del cassetto laterale --%>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Intercetta globalmente l'invio di qualsiasi form con classe 'cart-form'
            document.addEventListener("submit", function (e) {
                if (e.target && e.target.classList.contains("cart-form")) {
                    e.preventDefault(); // Previene il reload standard della pagina

                    const form = e.target;
                    const formData = new FormData(form);
                    const btn = form.querySelector(".cart-btn");
                    const contextPath = "${pageContext.request.contextPath}";

                    // Esegue la richiesta asincrona verso il CarrelloServlet
                    fetch(form.getAttribute("action"), {
                        method: "POST",
                        headers: { "X-Requested-With": "XMLHttpRequest" },
                        body: new URLSearchParams(formData)
                    })
                        .then(function (response) {
                            // Se non autenticato o reindirizzato a login, rimanda alla schermata di accesso
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

                            // Aggiorna la quantità totale visualizzata nel badge della navbar
                            const badge = document.querySelector(".cart-badge");
                            if (badge) {
                                let totalItems = 0;
                                data.forEach(p => totalItems += (p.quantita || 1));
                                badge.textContent = totalItems;
                            }

                            // Rigenera il markup HTML del drawer e mostra il cassetto laterale
                            rendercartDrawer(data, contextPath);
                            opencartDrawer();
                        })
                        .catch(function (err) {
                            console.error("Errore AJAX cart:", err);
                        });
                }
            });
        });

        // Funzione per generare il markup HTML degli elementi del carrello all'interno del drawer
        function rendercartDrawer(products, contextPath) {
            const container = document.getElementById("cart-drawer-content");
            if (!products || products.length === 0) {
                container.innerHTML = "<p class='empty-msg'>Il tuo carrello è vuoto.</p>";
                return;
            }

            let html = "";
            let subtotal = 0;

            // Itera sui prodotti ricevuti in formato JSON dal server
            products.forEach(function (p) {
                const prezzoOriginale = Number(p.prezzoIvato || p.prezzo);
                const prezzoFinale = Number(p.prezzoFinale || p.prezzo);
                const quantita = Number(p.quantita || 1);
                subtotal += (prezzoFinale * quantita);
                
                const prezzoFinaleStr = prezzoFinale.toFixed(2);
                const imgName = p.immagine ? p.immagine : "default.jpg";

                // Costruisce la visualizzazione del prezzo (eventualmente barrato se scontato)
                let priceHtml = '';
                if (prezzoOriginale > prezzoFinale) {
                    priceHtml = '<span class="old-price">€ ' + prezzoOriginale.toFixed(2) + '</span> ' +
                                '<span class="drawer-item-price">€ ' + prezzoFinaleStr + ' (IVA inc.)</span>';
                } else {
                    priceHtml = '<span class="drawer-item-price">€ ' + prezzoFinaleStr + ' (IVA inc.)</span>';
                }

                // Genera la card del singolo prodotto con thumbnail, info e pulsanti di azione
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

            // Riga del totale parziale calcolato
            html += '<div class="drawer-subtotal">' +
                '<strong>Totale:</strong> ' +
                '<span>€ ' + subtotal.toFixed(2) + '</span>' +
                '</div>';

            // Pulsante rapido per procedere alla cassa
            if (products.length > 0) {
                html += '<div class="drawer-action-btn-wrap">' +
                        '<button onclick="checkoutCart()" class="btn-cyber btn-cart">PROCEDI ALL\'ACQUISTO</button>' +
                        '</div>';
            }

            container.innerHTML = html;
        }

        // Reindirizza l'utente alla pagina carrello per il checkout
        window.checkoutCart = function() {
            window.location.href = "${pageContext.request.contextPath}/carrello";
        };

        // Mostra il pannello drawer e attiva lo sfondo scuro
        function opencartDrawer() {
            const drawer = document.getElementById("cart-drawer");
            const overlay = document.getElementById("cart-overlay");
            if (drawer) drawer.classList.add("open");
            if (overlay) overlay.classList.add("active");
        }

        // Chiude il pannello drawer e rimuove lo sfondo scuro
        function closecartDrawer() {
            const drawer = document.getElementById("cart-drawer");
            const overlay = document.getElementById("cart-overlay");
            if (drawer) drawer.classList.remove("open");
            if (overlay) overlay.classList.remove("active");
        }
    </script>
