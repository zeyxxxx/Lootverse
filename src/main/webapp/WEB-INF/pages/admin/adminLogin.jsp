<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/adminLogin.css">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container auth-container">
        <div class="cyber-divider-wrapper" style="margin-top: 20px; margin-bottom: 40px;">
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
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

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
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>