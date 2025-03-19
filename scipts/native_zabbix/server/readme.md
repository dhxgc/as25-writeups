# Порядок действий для развертывания zabbix-сервера на Astra linux

## Установка локали en_US.UTF-8
```
sudo sed -i "s/^#\s*\(en_US.UTF-8 UTF-8\)/\1/" /etc/locale.gen
sudo locale-gen en_US.UTF-8
sudo update-locale en_US.UTF-8
locale -a
```

## Установка пакетиков
```
sudo apt update
sudo apt install zabbix-server-pgsql zabbix-frontend-php php-pgsql syslog-ng-mod-astra
```
## Apache2
`/etc/php/*/apache2/php.ini`:
```
[Date]
date.timezone = Europe/Moscow
```
---
`/etc/hosts/`:
```
127.0.0.1   localhost
#127.0.1.1  astra
192.168.99.128  astra.example.com astra
```
---
`/etc/apache2/apache2.conf`:
```
AstraMode off
```
---
```
sudo systemctl restart apache2
```

## PGSQL

`sudo -u postgres psql`:
```
CREATE ROLE superadmin WITH LOGIN SUPERUSER PASSWORD 'P@ssw0rdSkills';

CREATE ROLE zabbix_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE DATABASE zabbix_db OWNER zabbix_user;

CREATE ROLE gitflic_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE DATABASE gitflic_db OWNER gitflic_user;

CREATE ROLE kc_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE DATABASE keycloak_db OWNER kc_user;

GRANT CONNECT ON DATABASE zabbix_db TO zabbix_user;
GRANT ALL PRIVILEGES ON DATABASE zabbix_db TO zabbix_user;

GRANT CONNECT ON DATABASE gitflic_db TO gitflic_user;
GRANT ALL PRIVILEGES ON DATABASE gitflic_db TO gitflic_user;

GRANT CONNECT ON DATABASE keycloak_db TO kc_user;
GRANT ALL PRIVILEGES ON DATABASE keycloak_db TO kc_user;
```
---
`/etc/postgres/*/main/pg_hba.conf`:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    zabbix_db       zabbix_user     0.0.0.0/0               scram-sha-256
host    gitflic_db      gitflic_user    0.0.0.0/0               scram-sha-256
host    keycloak_db     kc_user         0.0.0.0/0               scram-sha-256
```
---
```
sudo systemctl restart postgresql
```

## zabbix-server
```
zcat /usr/share/zabbix-server-pgsql/{schema,images,data}.sql.gz | psql -h localhost zabbix_db zabbix_user
```
---
```
sudo a2enconf zabbix-frontend-php
```
---
```
sudo systemctl restart apache2
```
---
```
sudo cp /usr/share/zabbix/conf/zabbix.conf.php.example /etc/zabbix/zabbix.conf.php
```
---
```
sudo chown www-data:www-data /etc/zabbix/zabbix.conf.php
```
---
`/etc/zabbix/zabbix.conf.php`:
```
$DB['TYPE'] = 'POSTGRESQL';
$DB['SERVER'] = 'localhost';
$DB['PORT'] = '0';
$DB['DATABASE'] = 'zabbix_db';
$DB['USER'] = 'zabbix_user';
$DB['PASSWORD'] = 'P@ssw0rdSkills';
```
---
```
sudo systemctl restart apache2
```
---
`/etc/zabbix/zabbix_server.conf`:
```
DBName=zabbix_db
DBUser=zabbix_user
DBPassword=P@ssw0rdSkills
```
---
```
sudo systemctl enable zabbix-server
sudo systemctl start zabbix-server
```

