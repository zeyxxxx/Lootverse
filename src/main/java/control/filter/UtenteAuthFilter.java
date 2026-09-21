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
 Filtro di sicurezza per l'area riservata al cliente loggato.
 Protegge le rotte che richiedono obbligatoriamente l'autenticazione (/checkout, /conferma-ordine, /storico-ordini, /lista-desideri).
 Se l'utente non e autenticato, blocca l'accesso e reindirizza alla pagina di login.
*/
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

    /*
     Verifica se nella sessione HTTP e presente l'oggetto 'utenteLoggato'.
     Se presente lascia proseguire la navigazione verso la servlet o pagina protetta,
     altrimenti reindirizza alla schermata di login.
    */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean isUtenteLoggato = (session != null && session.getAttribute("utenteLoggato") != null);

        if (isUtenteLoggato) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
    }
}
