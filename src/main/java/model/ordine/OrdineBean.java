package model.ordine;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public class OrdineBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int idUtente;
    private String stato;
    private LocalDate data;
    private BigDecimal totale;

    public OrdineBean() {
    }

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public LocalDate getData() {
        return data;
    }

    public void setData(LocalDate data) {
        this.data = data;
    }

    public BigDecimal getTotale() {
        return totale;
    }

    public void setTotale(BigDecimal totale) {
        this.totale = totale;
    }

    @Override
    public String toString() {
        return "OrdineBean [idOrdine=" + idOrdine 
                + ", idUtente=" + idUtente 
                + ", stato=" + stato 
                + ", data=" + data 
                + ", totale=" + totale + "]";
    }
}
