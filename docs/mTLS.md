# mTLS

These are not ideal!

## Env

Using a OpenBSD VM

``` bash
mkdir -p /root/ca
chmod 700 /root/ca
cd /root/ca
```

## Root CA (secp384r1)

This stays on the VM

``` bash
openssl ecparam -name secp384r1 -genkey -out root.key

openssl req -new -x509 -key root.key -days 3653 -out root.pem \
    -subj "/C=RO/O=<ORG>/CN=<Name>-Root-CA" \
    -addext "basicConstraints=critical,CA:TRUE,pathlen:0"
```

## Clients

``` bash
export NAME="whatever"

openssl ecparam -name prime256v1 -genkey -out ${NAME}.key
chmod 600 ${NAME}.key

openssl req -new -key ${NAME}.key -out ${NAME}.csr \
    -subj "/C=RO/O=<ORG>/CN=${NAME}-client-auth"

printf "extendedKeyUsage=clientAuth\nkeyUsage=digitalSignature\n" > ext.cnf

openssl x509 -req -in ${NAME}.csr -CA root.pem -CAkey root.key -CAcreateserial \
    -out ${NAME}.crt -days 825 -sha256 \
    -extfile ext.cnf

rm ext.cnf

openssl pkcs12 -export \
    -out ${NAME}.p12 \
    -inkey ${NAME}.key \
    -in ${NAME}.crt \
    -certfile root.pem \
    -name "<Name>-${NAME}"
```
