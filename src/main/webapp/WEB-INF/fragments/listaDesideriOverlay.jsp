<%-- ==============================================================================
     Frammento JSP: Lista Desideri Overlay (Drawer Laterale)
     Descrizione: Fornisce l'interfaccia a scomparsa laterale e lo sfondo oscurato
                  per visualizzare e gestire in tempo reale gli articoli aggiunti
                  alla wishlist dell'utente.
                  Include il codice JavaScript per intercettare l'aggiunta/rimozione AJAX
                  dai pulsanti a forma di cuore presenti nelle card prodotto,
                  il toggle visivo delle classi CSS, il rendering degli elementi
                  e l'azione di spostamento massivo verso il carrello.
     Uso: Incluso in fondo alle pagine dell'area cliente (es. index, catalogo, dettaglio).
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <%-- Foglio di stile dedicato per l'overlay e le animazioni del drawer della wishlist --%>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/static/css/listaDesideriOverlay.css?v=12">

    <%-- Sfondo oscurato (Backdrop): il click sullo sfondo chiude il cassetto --%>
    <div id="wishlist-overlay" class="wishlist-overlay" onclick="closeWishlistDrawer()"></div>

    <%-- Pannello Laterale Drawer per la Wishlist --%>
    <div id="wishlist-drawer" class="wishlist-drawer">
        <%-- Testata del Drawer con titolo Cyberpunk e pulsante di chiusura --%>
        <div class="drawer-header">
            <h3 class="cyber-title">Lista Desideri</h3>
            <button type="button" class="close-drawer-btn"
                onclick="closeWishlistDrawer()" title="Chiudi lista desideri">&times;</button>
        </div>

        <%-- Contenitore dinamico popolato da JavaScript con i prodotti salvati --%>
        <div id="drawer-content" class="drawer-content"></div>

        <%-- Piè di pagina del Drawer con link diretto alla pagina estesa della wishlist --%>
        <div class="drawer-footer">
            <a href="${pageContext.request.contextPath}/lista-desideri"
                class="btn btn-primary btn-block">
                Vai alla pagina completa ➔
            </a>
        </div>
    </div>

    <%-- Logica JavaScript per la sincronizzazione asincrona della wishlist --%>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Intercetta la sottomissione dei form wishlist ('wishlist-form') presenti nelle pagine
            document.addEventListener("submit", function (e) {
                if (e.target && e.target.classList.contains("wishlist-form")) {
                    e.preventDefault(); // Previene il ricaricamento della pagina del browser

                    const form = e.target;
                    const formData = new FormData(form);
                    const btn = form.querySelector(".wishlist-btn");
                    const contextPath = "${pageContext.request.contextPath}";

                    // Invia la richiesta asincrona alla ListaDesideriServlet
                    fetch(form.getAttribute("action"), {
                        method: "POST",
                        headers: { "X-Requested-With": "XMLHttpRequest" },
                        body: new URLSearchParams(formData)
                    })
                        .then(function (response) {
                            // Se la sessione è scaduta o l'utente non è autenticato, rimanda al login
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

                            // Gestione dinamica dello stato visivo del cuore (Attivo / Disattivo)
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

                            // Renderizza la lista aggiornata nel drawer e apre il pannello
                            renderWishlistDrawer(data, contextPath);
                            openWishlistDrawer();
                        })
                        .catch(function (err) {
                            console.error("Errore AJAX Wishlist:", err);
                        });
                }
            });
        });

        // Funzione per generare gli elementi HTML all'interno del drawer
        function renderWishlistDrawer(products, contextPath) {
            const container = document.getElementById("drawer-content");
            if (!products || products.length === 0) {
                container.innerHTML = "<p class='empty-msg'>La tua lista desideri è vuota.</p>";
                return;
            }

            let html = "";
            let subtotal = 0;

            // Ciclo sui prodotti salvati in wishlist
            products.forEach(function (p) {
                const prezzoOriginale = Number(p.prezzoIvato || p.prezzo);
                const prezzoFinale = Number(p.prezzoFinale || p.prezzo);
                subtotal += prezzoFinale;
                
                const prezzoFinaleStr = prezzoFinale.toFixed(2);
                const imgName = p.immagine ? p.immagine : "default.jpg";

                // Composizione del markup per il prezzo (normale o scontato)
                let priceHtml = '';
                if (prezzoOriginale > prezzoFinale) {
                    priceHtml = '<span class="old-price">€ ' + prezzoOriginale.toFixed(2) + '</span> ' +
                                '<span class="drawer-item-price">€ ' + prezzoFinaleStr + ' (IVA inc.)</span>';
                } else {
                    priceHtml = '<span class="drawer-item-price">€ ' + prezzoFinaleStr + ' (IVA inc.)</span>';
                }

                // Scheda del prodotto nella lista desideri con link dettaglio e form di aggiunta rapida al carrello
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

            // Calcolo e riassunto del valore economico stimato della wishlist
            html += '<div class="drawer-subtotal">' +
                '<strong>Subtotale (' + products.length + ' articoli):</strong> ' +
                '<span>€ ' + subtotal.toFixed(2) + '</span>' +
                '</div>';

            // Pulsante per spostare contemporaneamente tutti gli articoli nel carrello
            if (products.length > 0) {
                html += '<div class="drawer-action-btn-wrap">' +
                        '<button onclick="addAllWishlistToCart()" class="btn-cyber btn-cart">AGGIUNGI TUTTO AL CARRELLO</button>' +
                        '</div>';
            }

            container.innerHTML = html;
        }

        // Chiamata asincrona per trasferire tutti i desideri nel carrello della spesa
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

        // Apre il drawer e mostra lo sfondo oscurato
        function openWishlistDrawer() {
            const drawer = document.getElementById("wishlist-drawer");
            const overlay = document.getElementById("wishlist-overlay");
            if (drawer) drawer.classList.add("open");
            if (overlay) overlay.classList.add("active");
        }

        // Chiude il drawer e nasconde lo sfondo oscurato
        function closeWishlistDrawer() {
            const drawer = document.getElementById("wishlist-drawer");
            const overlay = document.getElementById("wishlist-overlay");
            if (drawer) drawer.classList.remove("open");
            if (overlay) overlay.classList.remove("active");
        }
    </script>