package model.listaDesideri;

import java.io.Serializable;

public class IncludeBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idProdotto;
    private int idLista;

    public IncludeBean() {
    }

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public int getIdLista() {
        return idLista;
    }

    public void setIdLista(int idLista) {
        this.idLista = idLista;
    }

    @Override
    public String toString() {
        return "IncludeBean [idProdotto=" + idProdotto 
                + ", idLista=" + idLista + "]";
    }
}