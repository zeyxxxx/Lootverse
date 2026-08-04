package control.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 
Filtro di sicurezza per l'area riservata Utente Registrato.
Intercetta le rotte che richiedono l'autenticazione obbligatoria.*/
@WebFilter(urlPatterns = {
    "/checkout",
    "/conferma-ordine",
    "/storico-ordini",
    "/lista-desideri"
})
public class UtenteAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean isUtenteLoggato = (session != null && session.getAttribute("utenteLoggato") != null);

        if (isUtenteLoggato) {
            // Utente autenticato: la richiesta prosegue normalmente
            chain.doFilter(request, response);
        } else {
            // Utente non autenticato: reindirizza al login
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
    }
}
