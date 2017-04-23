FROM httpd:2.4

WORKDIR /usr/local/apache2

ENV COMPOSE_TEMPLATE_VERSION 0.18.2

RUN mkdir conf.d/ && mkdir -p /templates && touch conf.d/vhost.conf
COPY templates/vhost.ctmpl /templates/vhost.ctmpl

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN echo "LoadModule slotmem_shm_module modules/mod_slotmem_shm.so" >> conf/httpd.conf \
    && echo "LoadModule proxy_module modules/mod_proxy.so" >> conf/httpd.conf \
    && echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> conf/httpd.conf \
    && echo "LoadModule proxy_ajp_module modules/mod_proxy_ajp.so" >> conf/httpd.conf \
    && echo "LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so" >> conf/httpd.conf \
    && echo "LoadModule proxy_balancer_module modules/mod_proxy_balancer.so" >> conf/httpd.conf \
    && echo "Include conf.d/vhost.conf" >> conf/httpd.conf

RUN apt-get update && apt-get install -y wget unzip\ 
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && wget https://releases.hashicorp.com/consul-template/${COMPOSE_TEMPLATE_VERSION}/consul-template_${COMPOSE_TEMPLATE_VERSION}_linux_amd64.zip \
    && unzip consul-template_${COMPOSE_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/consul-template \
    && rm -rf /tmp

EXPOSE 443
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["/usr/local/bin/httpd-foreground"]
