package model.carrello;

import java.io.Serializable;

public class ContieneBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idProdotto;
    private int idCarrello;
    private int quantita;

    public ContieneBean() {
    }

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public int getIdCarrello() {
        return idCarrello;
    }

    public void setIdCarrello(int idCarrello) {
        this.idCarrello = idCarrello;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    @Override
    public String toString() {
        return "ContieneBean [idProdotto=" + idProdotto 
                + ", idCarrello=" + idCarrello 
                + ", quantita=" + quantita + "]";
    }
}