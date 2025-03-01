**Пошаговая настройка RADIUS-сервера на Astra Linux 1.7 (с интеграцией ALD):**

---

### **0. Подготовка системы**
1. Обновите пакеты:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
2. Установите зависимости:
   ```bash
   sudo apt install freeradius freeradius-ldap freeradius-utils -y
   ```

---

### **1. Интеграция FreeRADIUS с ALD (LDAP)**
1. **Настройка модуля LDAP:**
   Отредактируйте файл `/etc/freeradius/3.0/mods-available/ldap`:
   ```bash
   sudo nano /etc/freeradius/3.0/mods-available/ldap
   ```
   ```nginx
   ldap {
       server = "ldap://<IP_ALD_Сервера>"  # Пример: ldap://dc-a.office.atom25.local
       identity = "cn=admin,dc=office,dc=atom25,dc=local"  # Учётная запись для доступа к LDAP
       password = <Пароль_администратора_ALD>
       basedn = "ou=users,dc=office,dc=atom25,dc=local"  # Базовый DN для поиска пользователей
       filter = "(uid=%{%{Stripped-User-Name}:-%{User-Name}})"
       ...
       update {
           control:Password-With-Header    := 'userPassword'
       }
   }
   ```
   Включите модуль:
   ```bash
   sudo ln -s /etc/freeradius/3.0/mods-available/ldap /etc/freeradius/3.0/mods-enabled/
   ```

2. **Добавьте клиента (Huawei AR) в `/etc/freeradius/3.0/clients.conf`:**
   ```bash
   sudo nano /etc/freeradius/3.0/clients.conf
   ```
   ```nginx
   client ar-router {
       ipaddr = <IP_Huawei_AR>  # Пример: 192.168.1.1
       secret = SecretKey123     # Секретный ключ (должен совпадать с ключом на AR)
   }
   ```

3. **Настройте атрибуты для Huawei:**
   Создайте файл `/etc/freeradius/3.0/policy.d/huawei`:
   ```bash
   sudo nano /etc/freeradius/3.0/policy.d/huawei
   ```
   ```nginx
   huawei_privilege {
       if (User-Name == "radadmin") {
           update reply {
               Huawei-Exec-Privilege = 15
           }
       }
   }
   ```
   Добавьте вызов политики в `site-enabled/default`:
   ```nginx
   authorize {
       ...
       huawei_privilege
   }
   ```

---

### **2. Настройка пользователя radadmin в ALD**
1. Убедитесь, что пользователь `radadmin` существует в ALD:
   ```bash
   ldapsearch -x -H ldap://dc-a.office.atom25.local -D "cn=admin,dc=office,dc=atom25,dc=local" -W -b "ou=users,dc=office,dc=atom25,dc=local" "uid=radadmin"
   ```
   Если его нет — создайте:
   ```bash
   ldapadd -x -H ldap://dc-a.office.atom25.local -D "cn=admin,dc=office,dc=atom25,dc=local" -W
   dn: uid=radadmin,ou=users,dc=office,dc=atom25,dc=local
   objectClass: inetOrgPerson
   uid: radadmin
   cn: Radius Admin
   userPassword: radpass
   ```

---

### **3. Запуск и проверка FreeRADIUS**
1. Перезапустите службу:
   ```bash
   sudo systemctl restart freeradius
   ```
2. Проверьте конфигурацию:
   ```bash
   sudo freeradius -X  # В режиме отладки
   ```
3. Тест аутентификации (в отдельном терминале):
   ```bash
   radtest radadmin radpass 127.0.0.1 0 testing123
   ```

---

### **4. Настройка Huawei AR для работы с RADIUS**
```bash
system-view
radius-server template RADIUS_OFFICE
 radius-server shared-key SecretKey123  # Ключ из clients.conf
 radius-server authentication <IP_Astra_Linux> 1812
aaa
 authentication-scheme RADIUS_AUTH
  authentication-mode radius local
 domain default
  authentication-scheme RADIUS_AUTH
```

---

### **5. Открытие портов на Astra Linux**
```bash
sudo ufw allow 1812/udp
sudo ufw allow 1813/udp
sudo ufw reload
```

---

### **6. Проверка работы**
1. С Huawei AR:
   ```bash
   test-aaa radadmin radpass radius-template RADIUS_OFFICE
   ```
   Ожидаемый вывод: `Authentication successful`.

2. С клиента CLI-A:
   ```bash
   ssh radadmin@<IP_AR>
   # Пароль: radpass (должен аутентифицироваться через RADIUS)
   ```

---

### **Важные замечания**
1. **Совместимость ALD:**
   - Если ALD использует Samba AD, настройте интеграцию через `sssd` и убедитесь, что FreeRADIUS имеет доступ к LDAP.
2. **Логирование:**
   - Логи FreeRADIUS: `/var/log/freeradius/radius.log`.
3. **Безопасность:**
   - Замените все примеры паролей (`SecretKey123`, `radpass`) на уникальные.
   - Используйте TLS для LDAP (`ldaps://`).
