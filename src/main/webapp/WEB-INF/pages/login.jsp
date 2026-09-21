<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/login.css">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container auth-container">
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

        <c:if test="${not empty successo}">
            <div class="alert alert-success">${successo}</div>
        </c:if>
        <c:if test="${not empty erroreLogin}">
            <div class="alert alert-danger">${erroreLogin}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="form-box">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${email}" required placeholder="Inserisci la tua email">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Inserisci la tua password">
            </div>
            <button type="submit" class="btn btn-primary">Accedi</button>
            <p class="auth-redirect">Non hai un account? <a href="${pageContext.request.contextPath}/registrazione">Registrati qui</a>.</p>
        </form>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>