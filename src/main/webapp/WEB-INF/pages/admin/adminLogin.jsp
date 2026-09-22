<%-- ==============================================================================
     Pagina JSP: Login Amministratore (Admin Login)
     Descrizione: Schermata di autenticazione riservata agli amministratori di sistema.
                  Richiede l'immissione di credenziali amministrative (email e password)
                  con estetica HUD/Cyberpunk dedicata e visualizzazione degli errori.
     Inoltrata da: AdminLoginServlet (GET /admin-login)
     Dati in ingresso:
       - requestScope.errore (String): eventuale messaggio di errore (credenziali errate, non admin)
       - requestScope.email (String): eventuale email precompilata per facilitare il reinserimento
     Form Action:
       - POST /admin-login: invia email e password alla servlet per la verifica del ruolo
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune contenente i meta tag HTML e i font di sistema --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il modulo di login amministratore con accenti neon rossi --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/adminLogin.css">

<body>
    <%-- Barra di navigazione principale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Contenitore principale per il modulo di autenticazione --%>
    <main class="container auth-container">
        <%-- Elemento grafico divisore in stile HUD/Cyberpunk per indicare il terminale admin --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module red-neon">// MODULE.ADMIN_LOGIN loading...</div>
            <div class="cyber-center-text red-neon">ACCEDI A LOOTVERSE ADMIN</div>
            <div class="cyber-right-hud red-neon">
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-text red-neon">SYS.ADM_99</div>
            </div>
        </div>

        <%-- Box per la notifica di errori di autenticazione o permessi mancanti --%>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <%-- Modulo di inserimento credenziali di accesso per gli amministratori --%>
        <form action="${pageContext.request.contextPath}/admin-login" method="post" class="form-box">
            <div class="form-group">
                <label for="email">Email Admin</label>
                <input type="email" id="email" name="email" value="${email}" required placeholder="Inserisci la tua email admin">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Inserisci la tua password admin">
            </div>
            <button type="submit" class="btn btn-primary">Accedi come Admin</button>
        </form>
    </main>

    <%-- Piè di pagina standard con copyright e link istituzionali --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>