<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <jsp:include page="/WEB-INF/fragments/header.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/gestioneProdotti.css">
    <title>Gestione Prodotti - Admin</title>
</head>
<body>
    <jsp:include page="/WEB-INF/fragments/navbar.jsp" />
    
    <main class="admin-container">
        <div class="admin-header">
            <h2>Gestione Catalogo Prodotti</h2>
        </div>

        <c:if test="${not empty sessionScope.messaggioSuccesso}">
            <div class="alert alert-success">
                ${sessionScope.messaggioSuccesso}
                <c:remove var="messaggioSuccesso" scope="session"/>
            </div>
        </c:if>
        
        <c:if test="${not empty errore}">
            <div class="alert alert-error">
                ${errore}
            </div>
        </c:if>

        <div class="admin-content-layout">
            <!-- Form Inserimento / Modifica -->
            <div class="crud-form-container">
            <c:choose>
                <c:when test="${not empty prodottoEdit}">
                    <h3>Modifica Prodotto #${prodottoEdit.idProdotto}</h3>
                    <form action="${pageContext.request.contextPath}/admin-prodotti" method="POST">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="idProdotto" value="${prodottoEdit.idProdotto}">
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nome">Nome Prodotto</label>
                                <input type="text" id="nome" name="nome" value="${prodottoEdit.nome}" required>
                            </div>
                            <div class="form-group">
                                <label for="prezzo">Prezzo (€)</label>
                                <input type="number" step="0.01" id="prezzo" name="prezzo" value="${prodottoEdit.prezzo}" required>
                            </div>
                            <div class="form-group">
                                <label for="sconto">Sconto (%)</label>
                                <input type="number" step="0.01" id="sconto" name="sconto" value="${prodottoEdit.sconto}" required>
                            </div>
                            <div class="form-group">
                                <label for="iva">IVA (%)</label>
                                <input type="number" step="0.01" id="iva" name="iva" value="${prodottoEdit.iva}" required>
                            </div>
                            <div class="form-group">
                                <label for="materiale">Materiale</label>
                                <input type="text" id="materiale" name="materiale" value="${prodottoEdit.materiale}" required>
                            </div>
                            <div class="form-group">
                                <label for="colore">Colore</label>
                                <input type="text" id="colore" name="colore" value="${prodottoEdit.colore}" required>
                            </div>
                            <div class="form-group">
                                <label for="dimensione">Dimensione</label>
                                <input type="text" id="dimensione" name="dimensione" value="${prodottoEdit.dimensione}" required>
                            </div>
                            <div class="form-group">
                                <label for="disponibilita">Disponibilità</label>
                                <select id="disponibilita" name="disponibilita">
                                    <option value="true" ${prodottoEdit.disponibilita ? 'selected' : ''}>Sì, Disponibile</option>
                                    <option value="false" ${!prodottoEdit.disponibilita ? 'selected' : ''}>No, Esaurito</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="immagine">Immagine Principale</label>
                                <input type="text" id="immagine" name="immagine" value="${prodottoEdit.immagine}" placeholder="default.jpg">
                            </div>
                            <div class="form-group">
                                <label for="immagine_carosello">Immagine Carosello</label>
                                <input type="text" id="immagine_carosello" name="immagine_carosello" value="${prodottoEdit.immagineCarosello}">
                            </div>
                            <div class="form-group">
                                <label for="tipo_arma">Tipo Arma</label>
                                <input type="text" id="tipo_arma" name="tipo_arma" value="${prodottoEdit.tipoArma}">
                            </div>
                            <div class="form-group">
                                <label for="tipo_media">Tipo Media</label>
                                <input type="text" id="tipo_media" name="tipo_media" value="${prodottoEdit.tipoMedia}">
                            </div>
                            <div class="form-group">
                                <label for="mondo_provenienza">Mondo Provenienza</label>
                                <input type="text" id="mondo_provenienza" name="mondo_provenienza" value="${prodottoEdit.mondoProvenienza}">
                            </div>
                            <div class="form-group full-width">
                                <label for="descrizione">Descrizione</label>
                                <textarea id="descrizione" name="descrizione" required>${prodottoEdit.descrizione}</textarea>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/admin-prodotti" class="btn-cyber secondary">Annulla Modifica</a>
                            <button type="submit" class="btn-cyber primary">Salva Modifiche</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <h3>Inserisci Nuovo Prodotto</h3>
                    <form action="${pageContext.request.contextPath}/admin-prodotti" method="POST">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nome">Nome Prodotto</label>
                                <input type="text" id="nome" name="nome" required>
                            </div>
                            <div class="form-group">
                                <label for="prezzo">Prezzo (€)</label>
                                <input type="number" step="0.01" id="prezzo" name="prezzo" required>
                            </div>
                            <div class="form-group">
                                <label for="sconto">Sconto (%)</label>
                                <input type="number" step="0.01" id="sconto" name="sconto" value="0.0" required>
                            </div>
                            <div class="form-group">
                                <label for="iva">IVA (%)</label>
                                <input type="number" step="0.01" id="iva" name="iva" value="22.0" required>
                            </div>
                            <div class="form-group">
                                <label for="materiale">Materiale</label>
                                <input type="text" id="materiale" name="materiale" required>
                            </div>
                            <div class="form-group">
                                <label for="colore">Colore</label>
                                <input type="text" id="colore" name="colore" required>
                            </div>
                            <div class="form-group">
                                <label for="dimensione">Dimensione</label>
                                <input type="text" id="dimensione" name="dimensione" required>
                            </div>
                            <div class="form-group">
                                <label for="disponibilita">Disponibilità</label>
                                <select id="disponibilita" name="disponibilita">
                                    <option value="true">Sì, Disponibile</option>
                                    <option value="false">No, Esaurito</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="immagine">Immagine Principale</label>
                                <input type="text" id="immagine" name="immagine" placeholder="default.jpg">
                            </div>
                            <div class="form-group">
                                <label for="immagine_carosello">Immagine Carosello</label>
                                <input type="text" id="immagine_carosello" name="immagine_carosello">
                            </div>
                            <div class="form-group">
                                <label for="tipo_arma">Tipo Arma</label>
                                <input type="text" id="tipo_arma" name="tipo_arma">
                            </div>
                            <div class="form-group">
                                <label for="tipo_media">Tipo Media</label>
                                <input type="text" id="tipo_media" name="tipo_media">
                            </div>
                            <div class="form-group">
                                <label for="mondo_provenienza">Mondo Provenienza</label>
                                <input type="text" id="mondo_provenienza" name="mondo_provenienza">
                            </div>
                            <div class="form-group full-width">
                                <label for="descrizione">Descrizione</label>
                                <textarea id="descrizione" name="descrizione" required></textarea>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-cyber primary">Inserisci Prodotto</button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Lista Prodotti -->
        <div class="table-responsive">
            <table class="cyber-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>Prezzo Base</th>
                        <th>Sconto</th>
                        <th>Prezzo Finale</th>
                        <th>Disp.</th>
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${prodotti}">
                        <tr>
                            <td>#${p.idProdotto}</td>
                            <td>${p.nome}</td>
                            <td>€ <fmt:formatNumber value="${p.prezzo}" pattern="0.00" /></td>
                            <td>${p.sconto}%</td>
                            <td>€ <fmt:formatNumber value="${p.prezzoFinale}" pattern="0.00" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.disponibilita}">
                                        <span class="badge-disp yes">Sì</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-disp no">No</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-links">
                                    <a href="${pageContext.request.contextPath}/admin-prodotti?action=edit&id=${p.idProdotto}" class="action-btn edit">Modifica</a>
                                    
                                    <form action="${pageContext.request.contextPath}/admin-prodotti" method="POST" style="display:inline;" onsubmit="return confirm('Sei sicuro di voler eliminare questo prodotto?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idProdotto" value="${p.idProdotto}">
                                        <button type="submit" class="action-btn delete">Elimina</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty prodotti}">
                        <tr>
                            <td colspan="7" style="text-align:center; padding: 20px;">Nessun prodotto trovato.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/fragments/footer.jsp" />
</body>
</html>