<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />

    <main class="container error-container">
        <div class="error-box">
            <h1 class="error-code">403</h1>
            <h2>Accesso Negato</h2>
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty errore}">
                        ${errore}
                    </c:when>
                    <c:otherwise>
                        Non disponi delle autorizzazioni necessarie per accedere a questa pagina.
                    </c:otherwise>
                </c:choose>
            </p>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary">Torna al Catalogo</a>
        </div>
    </main>

    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>