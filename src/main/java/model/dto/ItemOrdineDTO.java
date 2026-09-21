package model.dto;

import model.prodotto.ProdottoBean;

/*
 DTO per la visualizzazione del singolo prodotto acquistato in un ordine.
 Unisce le informazioni dell'articolo (tabella 'prodotto') con la quantita e il prezzo storico congelato al momento dell'acquisto (tabella 'dettaglio_ordine').
*/
public class ItemOrdineDTO {
    private ProdottoBean prodotto;
    private int quantita;
    private double prezzoAcquisto;

    public ItemOrdineDTO() {}

    public ItemOrdineDTO(ProdottoBean prodotto, int quantita, double prezzoAcquisto) {
        this.prodotto = prodotto;
        this.quantita = quantita;
        this.prezzoAcquisto = prezzoAcquisto;
    }

    public ProdottoBean getProdotto() { return prodotto; }
    public void setProdotto(ProdottoBean prodotto) { this.prodotto = prodotto; }

    public int getQuantita() { return quantita; }
    public void setQuantita(int quantita) { this.quantita = quantita; }

    public double getPrezzoAcquisto() { return prezzoAcquisto; }
    public void setPrezzoAcquisto(double prezzoAcquisto) { this.prezzoAcquisto = prezzoAcquisto; }

    public double getSubtotale() {
        double sub = quantita * prezzoAcquisto;
        return Math.round(sub * 100.0) / 100.0;
    }
}