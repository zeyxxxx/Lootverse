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

/*
 Filtro di sicurezza per l'area Amministratore.
 Protegge le rotte gestionali (/admin-prodotti, /admin-ordini, /admin-logout).
 Se l'admin non e loggato, blocca l'accesso e reindirizza alla schermata di login admin.
*/
@WebFilter(urlPatterns = {
    "/admin-prodotti",
    "/admin-ordini",
    "/admin-logout"
})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    /*
     Verifica se nella sessione HTTP e presente l'oggetto 'adminLoggato'.
     Se presente lascia proseguire la richiesta, altrimenti reindirizza a '/admin-login'.
    */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean isAdminLoggato = (session != null && session.getAttribute("adminLoggato") != null);

        if (isAdminLoggato) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin-login");
        }
    }

    @Override
    public void destroy() {
    }
}