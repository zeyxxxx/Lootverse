<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="cyber-footer footer">
    <!-- Barra Punti di Forza / Perks Bar -->
    <div class="footer-perks-wrapper">
        <div class="footer-perks-container">
            <div class="perk-card">
                <div class="perk-icon">
                    <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="1" y="3" width="15" height="13"></rect>
                        <polygon points="16 8 20 8 23 11 23 16 16 16 8"></polygon>
                        <circle cx="5.5" cy="18.5" r="2.5"></circle>
                        <circle cx="18.5" cy="18.5" r="2.5"></circle>
                    </svg>
                </div>
                <div class="perk-text">
                    <h4>Spedizioni Suborbitali</h4>
                    <p>Consegna in 24/48h nei settori abitati</p>
                </div>
            </div>

            <div class="perk-card">
                <div class="perk-icon">
                    <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                </div>
                <div class="perk-text">
                    <h4>Protocollo Sicuro</h4>
                    <p>Crittografia quantistica a 256-bit</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Contenitore Principale a Colonne -->
    <div class="footer-main-container">
        <!-- Colonna 1: Brand & Descrizione -->
        <div class="footer-col brand-col">
            <a href="${pageContext.request.contextPath}/index" class="footer-brand">
                <h2>LOOT<span>VERSE</span></h2>
            </a>
            <p class="brand-desc">
                Il marketplace definitivo per armi leggendarie, gadget cibernetici e artefatti dei multiversi. Forgiamo il futuro del tuo arsenale.
            </p>
            <div class="system-status">
                <span class="status-pulse"></span>
                <span class="status-text">SYS.STATUS: <strong class="neon-yellow">ONLINE</strong> // V2.6</span>
            </div>
            <div class="footer-socials">
                <a href="https://discord.com" target="_blank" rel="noopener noreferrer" class="social-icon" title="Discord" aria-label="Discord">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                        <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028c.462-.63.874-1.295 1.226-1.994.021-.041.001-.09-.041-.106a13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.929 1.793 8.18 1.793 12.061 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.894.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.028zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z"/>
                    </svg>
                </a>
                <a href="https://github.com/zeyxxxx/Lootverse" target="_blank" rel="noopener noreferrer" class="social-icon" title="GitHub" aria-label="GitHub">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                        <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0 0 24 12c0-6.63-5.37-12-12-12z"/>
                    </svg>
                </a>
                <a href="#" class="social-icon" title="Terminal Network" aria-label="Terminal">
                    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="4 17 10 11 4 5"></polyline>
                        <line x1="12" y1="19" x2="20" y2="19"></line>
                    </svg>
                </a>
            </div>
        </div>

        <!-- Colonna 2: Navigazione -->
        <div class="footer-col">
            <h3 class="footer-title">Navigazione</h3>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/index">Home Page</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo Completo</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo?categoria=Armi">Arsenale & Armi</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo?categoria=Gadget">Cyber-Gadget</a></li>
                <li><a href="${pageContext.request.contextPath}/carrello">Carrello Spesa</a></li>
            </ul>
        </div>

        <!-- Colonna 3: Utente & Servizi -->
        <div class="footer-col">
            <h3 class="footer-title">Area Utente</h3>
            <ul class="footer-links">
                <c:choose>
                    <c:when test="${not empty sessionScope.utenteLoggato}">
                        <li><a href="${pageContext.request.contextPath}/carrello">Carrello (${sessionScope.cartBadgeCount != null ? sessionScope.cartBadgeCount : 0})</a></li>
                        <li><a href="${pageContext.request.contextPath}/lista-desideri">Lista Desideri</a></li>
                        <li><a href="${pageContext.request.contextPath}/storico-ordini">I Miei Ordini</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout">Termina Sessione</a></li>
                    </c:when>
                    <c:when test="${not empty sessionScope.adminLoggato}">
                        <li><a href="${pageContext.request.contextPath}/admin-prodotti">Gestione Prodotti</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin-ordini">Gestione Ordini</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin-logout">Logout Amministratore</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login">Accedi al Terminale</a></li>
                        <li><a href="${pageContext.request.contextPath}/registrazione">Crea Nuovo Account</a></li>
                        <li><a href="${pageContext.request.contextPath}/lista-desideri">Lista Desideri</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin-login">Accesso Admin</a></li>
                    </c:otherwise>
                </c:choose>
                <li><a href="#top" onclick="window.scrollTo({top: 0, behavior: 'smooth'}); return false;">Torna in Cima &uarr;</a></li>
            </ul>
        </div>

        <!-- Colonna 4: Progetto Universitario TSW -->
        <div class="footer-col project-col">
            <h3 class="footer-title">Progetto Accademico</h3>
            <div class="project-badge">
                <span class="unisa-tag">UNISA // TSW</span>
            </div>
            <p class="project-desc">
                Piattaforma e-commerce realizzata per il corso di <strong>Tecnologie Software per il Web</strong>.
            </p>
            <div class="project-meta">
                <p><span class="meta-label">Ateneo:</span> Università degli Studi di Salerno</p>
                <p><span class="meta-label">Dipartimento:</span> Informatica (DI)</p>
                <p><span class="meta-label">Anno Accad.:</span> 2025 / 2026</p>
            </div>
        </div>
    </div>

    <!-- Bottom Bar / Copyright -->
    <div class="footer-bottom-bar">
        <div class="footer-bottom-content">
            <p class="copyright-text">
                &copy; 2026 <strong>LOOTVERSE</strong>. Progetto Universitario TSW — UNISA. Tutti i diritti riservati.
            </p>
            <div class="footer-bottom-badges">
                <span class="cyber-chip">SECURE 256-BIT</span>
                <span class="cyber-chip">NEON ENGINE V2</span>
                <span class="cyber-chip unisa-chip">TSW UNISA</span>
            </div>
        </div>
    </div>
</footer>

<%-- Script JavaScript principale del progetto --%>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

<%-- Inclusione del frammento per il pannello laterale (overlay) della Wishlist --%>
<jsp:include page="/WEB-INF/fragments/listaDesideriOverlay.jsp" />
<jsp:include page="/WEB-INF/fragments/carrelloOverlay.jsp" />