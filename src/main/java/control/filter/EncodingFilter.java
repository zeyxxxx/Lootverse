package control.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

/*
 Filtro globale per la codifica dei caratteri.
 Intercetta qualsiasi richiesta in ingresso e imposta l'encoding UTF-8 uniforme sia sulla richiesta che sulla risposta.
*/
@WebFilter("/*")
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    /*
     Esegue l'impostazione dell'encoding UTF-8 e passa la richiesta al filtro o alla servlet successiva nella catena.
    */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}