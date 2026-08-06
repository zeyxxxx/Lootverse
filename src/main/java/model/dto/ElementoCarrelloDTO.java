package model.dto;

import model.prodotto.ProdottoBean;

/**
 * Data Transfer Object per la visualizzazione del Carrello.
 * Accoppia il ProdottoBean con la quantità selezionata dall'utente.
 */
public class ElementoCarrelloDTO {
    
    private ProdottoBean prodotto;
    private int quantita;

    public ElementoCarrelloDTO() {
    }

    public ElementoCarrelloDTO(ProdottoBean prodotto, int quantita) {
        this.prodotto = prodotto;
        this.quantita = quantita;
    }

    public ProdottoBean getProdotto() {
        return prodotto;
    }

    public void setProdotto(ProdottoBean prodotto) {
        this.prodotto = prodotto;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    // Subtotale ivato calcolato per la JSP
    public double getSubtotale() {
        if (prodotto == null) return 0.0;
        double sub = prodotto.getPrezzoFinale() * quantita;
        return Math.round(sub * 100.0) / 100.0;
    }
}