

    Generate RSA key:
~~~
openssl genrsa -out key.pem 1024 
openssl rsa -in key.pem -text -noout
~~~
    Save public key in pub.pem file:
~~~
openssl rsa -in key.pem -pubout -out pub.pem 
openssl rsa -in pub.pem -pubin -text -noout 
~~~
    Encrypt some data:
~~~
echo test test test > file.txt 
openssl pkeyutl -encrypt -inkey pub.pem -pubin -in file.txt -out file.bin 
~~~
    Decrypt encrypted data:
~~~
openssl pkeyutl -decrypt -inkey key.pem -in file.bin 
~~~
