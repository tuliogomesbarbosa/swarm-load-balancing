#!/bin/bash
httpd -k start
consul-template -consul-addr=$CONSUL_URL -template="/templates/vhost.ctmpl:/usr/local/apache2/conf.d/vhost.conf:httpd -k graceful"
