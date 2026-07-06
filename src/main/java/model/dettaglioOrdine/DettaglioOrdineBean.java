package model.dettaglioOrdine;

import java.io.Serializable;
import java.math.BigDecimal;

public class DettaglioOrdineBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int idProdotto;
    private BigDecimal prezzo;
    private BigDecimal iva;
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

    public BigDecimal getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(BigDecimal prezzo) {
        this.prezzo = prezzo;
    }

    public BigDecimal getIva() {
        return iva;
    }

    public void setIva(BigDecimal iva) {
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
