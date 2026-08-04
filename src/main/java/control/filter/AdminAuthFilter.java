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
 
Filtro di sicurezza per l'area Amministratore.
Intercetta le richieste dirette alle Servlet admin e verifica l'autenticazione.*/
@WebFilter(urlPatterns = {
    "/admin-prodotti",
    "/admin-ordini",
    "/admin-logout"
})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inizializzazione eventuale del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean isAdminLoggato = (session != null && session.getAttribute("adminLoggato") != null);

        if (isAdminLoggato) {
            // Admin autenticato: consente il proseguimento della richiesta
            chain.doFilter(request, response);
        } else {
            // Admin non autenticato: reindirizza alla pagina di login admin
            res.sendRedirect(req.getContextPath() + "/admin-login");
        }
    }

    @Override
    public void destroy() {
        // Pulizia risorse eventuale
    }
}