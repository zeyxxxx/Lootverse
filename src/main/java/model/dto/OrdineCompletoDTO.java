package model.dto;

import java.util.List;
import model.ordine.OrdineBean;

/*
 DTO per la visualizzazione dell'ordine completo nella pagina di riepilogo o dettaglio ordine.
 Unisce i dati generali dell'ordine (tabella 'ordine') con la lista degli articoli acquistati (tabelle 'dettaglio_ordine' e 'prodotto').
*/
public class OrdineCompletoDTO {
    private OrdineBean ordine;
    private List<ItemOrdineDTO> prodottiAcquistati;

    public OrdineCompletoDTO() {}

    public OrdineCompletoDTO(OrdineBean ordine, List<ItemOrdineDTO> prodottiAcquistati) {
        this.ordine = ordine;
        this.prodottiAcquistati = prodottiAcquistati;
    }

    public OrdineBean getOrdine() { return ordine; }
    public void setOrdine(OrdineBean ordine) { this.ordine = ordine; }

    public List<ItemOrdineDTO> getProdottiAcquistati() { return prodottiAcquistati; }
    public void setProdottiAcquistati(List<ItemOrdineDTO> prodottiAcquistati) { this.prodottiAcquistati = prodottiAcquistati; }
}	