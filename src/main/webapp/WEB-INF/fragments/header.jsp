<%--
 ==============================================================================
 Frammento JSP: /WEB-INF/fragments/header.jsp
 Descrizione: Frammento riutilizzabile per la sezione <head> HTML di tutte le pagine.
              Configura i metatag essenziali (charset UTF-8, viewport responsive),
              il titolo predefinito dell'applicazione, il foglio di stile globale (global.css),
              le icone Google Material Symbols Outlined e i web font 'Orbitron' e 'Rajdhani'.
 Incluso tramite: <jsp:include page="/WEB-INF/fragments/header.jsp" />
 ==============================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
    <%-- Metatag per la codifica caratteri e responsive design su dispositivi mobili --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <%-- Titolo del portale e-commerce --%>
    <title>Lootverse | E-Commerce Cyberpunk</title>
    
    <%-- Foglio di stile globale con variabili di tema (:root), navbar, footer e pulsanti --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/global.css">
    
    <%-- Icone Google Material Symbols Outlined (carrello, preferiti, menu e chiusura) --%>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=favorite,shopping_cart,menu,close" />
    
    <%-- Preconnessione ai server Google Fonts per velocizzare il rendering tipografico --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <%-- Font futuristici: 'Orbitron' per i titoli HUD e 'Rajdhani' per il corpo del testo --%>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Rajdhani:wght@500;700&display=swap" rel="stylesheet">
</head>