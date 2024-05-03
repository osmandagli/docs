~~~
openssl genrsa -out rootCAKey.pem 2048
~~~

~~~
openssl req -x509 -sha256 -new -nodes -key rootCAKey.pem -days 3650 -out rootCACert.pem
~~~

~~~
openssl x509 -in rootCACert.pem -text
~~~
