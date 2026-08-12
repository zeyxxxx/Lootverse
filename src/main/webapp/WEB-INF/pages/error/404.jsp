<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css?v=1">
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <main class="container error-container">
        <div class="error-box">
            <h1 class="error-code">404</h1>
            <h2>SYS.ERR: CONNECTION_LOST</h2>
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty errore}">
                        ${errore}
                    </c:when>
                    <c:otherwise>
                        Segnale debole. La risorsa richiesta non esiste o è stata cancellata dai registri.
                    </c:otherwise>
                </c:choose>
            </p>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-return">Torna alla Base</a>
        </div>
    </main>

    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>