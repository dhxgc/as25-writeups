mkdir /docker/kc2/_здесь_все_лежит

 - Ключ из `pfx`
```bash
openssl pkcs12 -in kc.pfx -nocerts -out kc.key -nodes
```

 - Серт из `pfx`
```bash
openssl pkcs12 -in kc.pfx -clcerts -nokeys -out kc.crt -nodes
```

 - Права + я убрал всякое говно из серта
```bash
chown keycloak:keycloak kc.*
chmod -R 644 kc.*
```
