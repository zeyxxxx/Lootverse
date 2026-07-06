package model.admin;

import java.io.Serializable;

public class AdminBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idAdmin;
    private String nome;
    private String email;
    private String passwordHash;

    public AdminBean() {
    }

    public int getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(int idAdmin) {
        this.idAdmin = idAdmin;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
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

    @Override
    public String toString() {
        return "AdminBean [idAdmin=" + idAdmin + ", nome=" + nome + ", email=" + email + "]";
    }
}