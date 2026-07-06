package model.listaDesideri;

import java.io.Serializable;

public class ListaDesideriBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idListaDesideri;
    private int prodotti;
    private int idUtente;

    public ListaDesideriBean() {
    }

    public int getIdListaDesideri() {
        return idListaDesideri;
    }

    public void setIdListaDesideri(int idListaDesideri) {
        this.idListaDesideri = idListaDesideri;
    }

    public int getProdotti() {
        return prodotti;
    }

    public void setProdotti(int prodotti) {
        this.prodotti = prodotti;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    @Override
    public String toString() {
        return "ListaDesideriBean [idListaDesideri=" + idListaDesideri
                + ", prodotti=" + prodotti
                + ", idUtente=" + idUtente + "]";
    }
}