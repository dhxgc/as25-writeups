# Порядок действий для развертывания pgsql + zabbix-агента на Astra linux

```
sudo apt install -y zabbix-agent php-pgsql
```
---
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

```
sudo mkdir -p /etc/zabbix/psk
sudo chmod 755 /etc/zabbix/psk
```
---
```
openssl rand -hex 32 | sudo tee /etc/zabbix/psk/zabbix_agent.psk
```
---
```
sudo chown zabbix:zabbix /etc/zabbix/psk/zabbix-agent.psk
sudo chmod 600 /etc/zabbix/psk/zabbix_agent.psk
```
---
```
sudo systemctl restart zabbix-agent
```
---
`/etc/zabbix/zabbix_agentd.conf`:
```
Server=192.168.10.1
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=dc01_psk
TLSPSKFile=/etc/zabbix/psk/zabbix_agent.psk
```
---
В веб-интерфейсе:
```
    Configuration → Hosts → Create host

        Host name: astra

        Groups: Linux servers

        IP address: IP_адрес_DC-01

        Templates: Template OS Linux by Zabbix agent

    Encryption:

        PSK identity: dc01_psk

        PSK key: (вставить содержимое файла zabbix_agentd.psk)
```
