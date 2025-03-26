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

> синхронизация - по рук-ву администратора

---

> тему нужно выбрать в настроках realm'a

---

> если надо обновить - то справа сверху у user federation есть три точки, там можно сразу синхронизировать группы/пользаков

---

 - 2 и 3 пункты (токены):
```
Realm Settings -> Tokens:
    Revoke Refresh Token -> Enabled
    Acces Token Lifespan -> 2 minutes
    Client Login Timeout -> 5 Minutes
```