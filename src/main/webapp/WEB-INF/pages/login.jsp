<%-- ==============================================================================
     Pagina JSP: Login Utente (Accesso Area Clienti)
     Descrizione: Schermata di autenticazione per gli utenti registrati di Lootverse.
                  Permette l'accesso tramite email e password, mostra eventuali notifiche di successo
                  (es. avvenuta registrazione) o messaggi di errore (es. credenziali errate),
                  e include il link di reindirizzamento alla form di registrazione per nuovi utenti.
     Inoltrata da: LoginServlet (GET /login)
     Dati in ingresso:
       - requestScope.successo (String): eventuale messaggio di esito positivo (es. registrazione completata)
       - requestScope.erroreLogin (String): messaggio descrittivo dell'errore di autenticazione
       - requestScope.email (String): email precedentemente inserita per precompilazione campo
     Form Action:
       - POST /login: sottomissione credenziali per verifica hash password e creazione sessione
     ============================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<%-- Inclusione dell'header comune con viewport e tag di configurazione base --%>
<jsp:include page="/WEB-INF/fragments/header.jsp" />

<%-- Foglio di stile dedicato per il modulo di login clienti --%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/login.css">

<body>
    <%-- Barra di navigazione principale del portale --%>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <%-- Sezione principale di autenticazione con estetica cyberpunk --%>
    <main class="container auth-container">
        <%-- Barra superiore decorativa HUD con accenti neon verdi --%>
        <div class="cyber-divider-wrapper">
            <div class="cyber-divider"></div>
            <div class="cyber-left-module green-neon">// MODULE.LOGIN loading...</div>
            <div class="cyber-center-text green-neon">ACCEDI A LOOTVERSE</div>
            <div class="cyber-right-hud green-neon">
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-line"></div>
                <div class="cyber-hud-text green-neon">SYS.DAT_77</div>
            </div>
        </div>

        <%-- Notifica di operazione completata con successo (es. registrazione effettuata) --%>
        <c:if test="${not empty successo}">
            <div class="alert alert-success">${successo}</div>
        </c:if>

        <%-- Notifica di errore di credenziali errate o account inesistente --%>
        <c:if test="${not empty erroreLogin}">
            <div class="alert alert-danger">${erroreLogin}</div>
        </c:if>

        <%-- Modulo di inserimento credenziali utente --%>
        <form action="${pageContext.request.contextPath}/login" method="post" class="form-box">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${email}" required placeholder="Inserisci la tua email">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Inserisci la tua password">
            </div>
            <%-- Pulsante di accesso al sistema --%>
            <button type="submit" class="btn btn-primary">Accedi</button>
            
            <%-- Link per utenti non ancora registrati --%>
            <p class="auth-redirect">Non hai un account? <a href="${pageContext.request.contextPath}/registrazione">Registrati qui</a>.</p>
        </form>
    </main>

    <%-- Piè di pagina standard del sito --%>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>