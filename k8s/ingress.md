# Ingress

~~~
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: k8s-dashboard
  namespace: monitoring
spec:
  ingressClassName: nginx
  rules:
    - host: ip10-244-155-75-user2805-80.bulutbilisimciler.com
      http:
        paths:
          - pathType: Prefix
            backend:
              service:
                name: dashboard-kubernetes-dashboard
                port:
                  number: 443
            path: /dahsboard
  # This section is only required if TLS is to be enabled for the Ingress
  tls:
    - hosts:
      - ip10-244-155-75-user2805-80.bulutbilisimciler.com
      secretName: bbk-tls-secret
~~~

tls

~~~
  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
~~~
~~~

##  Ingress redirect

nginx.ingress.kubernetes.io/proxy-redirect-from: ~^http://([^/]+)/(pgadmin4/)?(.*)$

nginx.ingress.kubernetes.io/proxy-redirect-to: https://$1/pgadmin4/$3


