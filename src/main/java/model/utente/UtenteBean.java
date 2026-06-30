package model.utente;

import java.io.Serializable;

public class UtenteBean {
	 private static final long serialVersionUID = 1L;

	    private int idUtente;
	    private String email;
	    private String passwordHash;
	    private String nome;
	    private String cognome;

	    public UtenteBean() {
	    }

	    public int getIdUtente() {
	        return idUtente;
	    }

	    public void setIdUtente(int idUtente) {
	        this.idUtente = idUtente;
	    }

	    public String getEmail() {
	        return email;
	    }

	    public void setEmail(String email) {
	        this.email = email;
	    }
	    
	    public String getPasswordHash() {
	        return passwordHash;
	    }

	    public void setPasswordHash(String passwordHash) {
	        this.passwordHash = passwordHash;
	    }

	    public String getNome() {
	        return nome;
	    }

	    public void setNome(String nome) {
	        this.nome = nome;
	    }

	    public String getCognome() {
	        return cognome;
	    }

	    public void setCognome(String cognome) {
	        this.cognome = cognome;
	    }

	    @Override
	    public String toString() {
	        return "UtenteBean [idUtente=" + idUtente + ", email=" + email + ", nome=" + nome + ", cognome=" + cognome + "]";
	    }

}
