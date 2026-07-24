package model.dettaglioOrdine;

import java.io.Serializable;

public class DettaglioOrdineBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int idProdotto;
    private double prezzo;
    private double iva;
    private int quantita;

    public DettaglioOrdineBean() {
    }

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public double getIva() {
        return iva;
    }

    public void setIva(double iva) {
        this.iva = iva;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    @Override
    public String toString() {
        return "DettaglioOrdineBean [idOrdine=" + idOrdine 
                + ", idProdotto=" + idProdotto 
                + ", prezzo=" + prezzo 
                + ", iva=" + iva 
                + ", quantita=" + quantita + "]";
    }
}