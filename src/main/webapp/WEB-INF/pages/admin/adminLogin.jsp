<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    <main class="container auth-container">
        <h2>Accesso Riservato Amministratore</h2>
        <c:if test="${not empty errore}">
            <div class="alert alert-danger">${errore}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin-login" method="post" class="form-box">
            <div class="form-group">
                <label for="username">Username Admin</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary">Accedi come Admin</button>
        </form>
    </main>
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>