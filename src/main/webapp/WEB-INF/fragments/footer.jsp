<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer">
    <div class="footer-content">
        <p>&copy; <%= java.time.Year.now().getValue() %> Lootverse. Tutti i diritti riservati.</p>
        <p class="credits">Progetto Universitario TSW — Università degli Studi di Salerno</p>
    </div>
</footer>

<script src="<%= request.getContextPath() %>/static/js/main.js"></script>