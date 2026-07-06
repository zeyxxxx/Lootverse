
package model.prodotto;

import java.io.Serializable;

public class ProdottoBean implements Serializable {
    private static final long serialVersionUID = 1L;

    // Attributi privati coerenti con il database SQL
    private int idProdotto;
    private double prezzo; // Prezzo base (escluso IVA o prima dello sconto)
    private String descrizione;
    private boolean disponibilita; 
    private double sconto; // Es. 10.00 per il 10%
    private double iva; // Es. 22.00 per il 22%
    private int id_admin; 
    private String nome;
    private String materiale;
    private String colore;
    private String dimensione;

    // Costruttore vuoto
    public ProdottoBean() {
    }

    // --- METODI CALCOLATI (SOLO GETTER) ---

    /**
     * Calcola il prezzo finale del prodotto applicando prima lo sconto (se presente)
     * e successivamente l'IVA.
     */
    public double getPrezzoFinale() {
        // 1. Applica lo sconto al prezzo base
        double prezzoScontato = prezzo * (1 - (sconto / 100.0));
        
        // 2. Aggiungi l'iva al prezzo scontato
        double prezzoIvato = prezzoScontato * (1 + (iva / 100.0));
        
        // Arrotonda a due cifre decimali
        return Math.round(prezzoIvato * 100.0) / 100.0;
    }

    // --- GETTER E SETTER STANDARD ---

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

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public boolean isDisponibilita() {
        return disponibilita;
    }

    public void setDisponibilita(boolean disponibilita) {
        this.disponibilita = disponibilita;
    }

    public double getSconto() {
        return sconto;
    }

    public void setSconto(double sconto) {
        this.sconto = sconto;
    }

    public double getIva() {
        return iva;
    }

    public void setIva(double iva) {
        this.iva = iva;
    }

    public int getId_admin() {
        return id_admin;
    }

    public void setId_admin(int id_admin) {
        this.id_admin = id_admin;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getMateriale() {
        return materiale;
    }

    public void setMateriale(String materiale) {
        this.materiale = materiale;
    }

    public String getColore() {
        return colore;
    }

    public void setColore(String colore) {
        this.colore = colore;
    }

    public String getDimensione() {
        return dimensione;
    }

    public void setDimensione(String dimensione) {
        this.dimensione = dimensione;
    }

    // Metodo toString
    @Override
    public String toString() {
        return "ProdottoBean {" +
                "idProdotto=" + idProdotto +
                ", prezzo=" + prezzo +
                ", prezzoFinale=" + getPrezzoFinale() + // Mostra il prezzo calcolato nel toString
                ", descrizione='" + descrizione + '\'' +
                ", disponibilita=" + disponibilita +
                ", sconto=" + sconto +
                ", iva=" + iva +
                ", id_admin=" + id_admin +
                ", nome='" + nome + '\'' +
                ", materiale='" + materiale + '\'' +
                ", colore='" + colore + '\'' +
                ", dimensione='" + dimensione + '\'' +
                '}';
    }
}