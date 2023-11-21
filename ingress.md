#  Ingress redirect

nginx.ingress.kubernetes.io/proxy-redirect-from: ~^http://([^/]+)/(pgadmin4/)?(.*)$
nginx.ingress.kubernetes.io/proxy-redirect-to: https://$1/pgadmin4/$3
