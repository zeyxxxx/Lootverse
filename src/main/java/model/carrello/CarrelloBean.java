package model.carrello;

import java.io.Serializable;
import java.time.LocalDate;

public class CarrelloBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idCarrello;
    private LocalDate data;
    private int idUtente;

    public CarrelloBean() {
    }

    public int getIdCarrello() {
        return idCarrello;
    }

    public void setIdCarrello(int idCarrello) {
        this.idCarrello = idCarrello;
    }

    public LocalDate getData() {
        return data;
    }

    public void setData(LocalDate data) {
        this.data = data;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    @Override
    public String toString() {
        return "CarrelloBean [idCarrello=" + idCarrello + ", data=" + data + ", idUtente=" + idUtente + "]";
    }
}
