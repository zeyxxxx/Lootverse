<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/registrazione.css">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container auth-container">
        <h2>Registrazione Nuovo Utente</h2>

        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>
        <c:if test="${not empty erroreCampiVuoti}">
            <div class="alert alert-danger">${erroreCampiVuoti}</div>
        </c:if>
        <c:if test="${not empty erroreGiàPresente}">
            <div class="alert alert-danger">${erroreGiàPresente}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/registrazione" method="post" class="form-box" id="registrationForm">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome" value="${nome}" required>
            </div>

            <div class="form-group">
                <label for="cognome">Cognome</label>
                <input type="text" id="cognome" name="cognome" value="${cognome}" required>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${email}" required>
                <span id="emailAjaxMsg" class="error-msg"></span>
                <c:if test="${not empty erroreEmail}">
                    <span class="error-msg">${erroreEmail}</span>
                </c:if>
            </div>

            <div class="form-group">
    <label for="telefono">Telefono</label>
    <div class="phone-input-container">
        <select id="prefisso" name="prefisso" class="select-prefisso">
            <option value="+39" ${prefisso == '+39' || empty prefisso ? 'selected' : ''}>🇮🇹 +39 (Italia)</option>
            <option value="+34" ${prefisso == '+34' ? 'selected' : ''}>🇪🇸 +34 (Spagna)</option>
            <option value="+33" ${prefisso == '+33' ? 'selected' : ''}>🇫🇷 +33 (Francia)</option>
            <option value="+49" ${prefisso == '+49' ? 'selected' : ''}>🇩🇪 +49 (Germania)</option>
            <option value="+44" ${prefisso == '+44' ? 'selected' : ''}>🇬🇧 +44 (Regno Unito)</option>
            <option value="+41" ${prefisso == '+41' ? 'selected' : ''}>🇨🇭 +41 (Svizzera)</option>
            <option value="+43" ${prefisso == '+43' ? 'selected' : ''}>🇦🇹 +43 (Austria)</option>
            <option value="+1"  ${prefisso == '+1'  ? 'selected' : ''}>🇺🇸 +1 (USA / Canada)</option>
            <option value="+351" ${prefisso == '+351' ? 'selected' : ''}>🇵🇹 +351 (Portogallo)</option>
            <option value="+31" ${prefisso == '+31' ? 'selected' : ''}>🇳🇱 +31 (Paesi Bassi)</option>
        </select>
        
        <input type="tel" id="telefono" name="telefono" value="${telefono}" placeholder="3123456789" required>
    </div>
    <c:if test="${not empty erroreTelefono}">
        <span class="error-msg">${erroreTelefono}</span>
    </c:if>
</div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <c:if test="${not empty errorePassword}">
                    <span class="error-msg">${errorePassword}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="confermaPassword">Conferma Password</label>
                <input type="password" id="confermaPassword" name="confermaPassword" required>
                <c:if test="${not empty erroreConfermaPassword}">
                    <span class="error-msg">${erroreConfermaPassword}</span>
                </c:if>
            </div>

            <button type="submit" class="btn btn-primary">Registrati</button>
        </form>
        <p class="auth-redirect">Hai già un account? <a href="${pageContext.request.contextPath}/login">Accedi qui</a>.</p>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>