```
sudo apt install -y docker docker-compose ca-certificates curl gnupg lsb-release apt-transport-https
```
---
Структура:
```
zabbix-project/
├── docker-compose.yml
├── pgsql/
│   ├── Dockerfile
│   └── init.sql
└── nginx/
    └── ssl/
        ├── zabbix.crt
        └── zabbix.key
```
---
Серты:
```
mkdir -p zabbix/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout zabbix/nginx/ssl/zabbix.key \
  -out zabbix/nginx/ssl/zabbix.crt \
  -subj "/CN=zabbix.atom25.local"
```
---
`pgsql/Dockerfile`:
```
FROM postgres:15
COPY init.sql /docker-entrypoint-initdb.d/
```
---
`pgsql/init.sql`:
```
CREATE USER superadmin WITH SUPERUSER CREATEDB LOGIN PASSWORD 'P@ssw0rdSkills';

CREATE USER zabbix_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE USER gitflic_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE USER kc_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';

CREATE DATABASE zabbix_db OWNER zabbix_user;
CREATE DATABASE gitflic_db OWNER gitflic_user;
CREATE DATABASE kc_db OWNER kc_user;
```
---
`zabbix-project/docker-compose.yml`:
```
version: '3.7'
services:
  # PostgreSQL
  pgsql:
    build: ./pgsql
    image: pgsql:as25
    container_name: pgsql-server
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: P@ssw0rdSkills
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - zabbix-net
    restart: always

  # Zabbix Server
  zabbix-server:
    image: zabbix/zabbix-server-pgsql:alpine-6.4-latest
    container_name: zabbix-server
    depends_on:
      - pgsql
    environment:
      DB_SERVER_HOST: pgsql
      POSTGRES_USER: zabbix_user
      POSTGRES_PASSWORD: P@ssw0rdSkills
      POSTGRES_DB: zabbix_db
    ports:
      - "10051:10051"
    networks:
      - zabbix-net
    restart: unless-stopped

  # Zabbix Web
  zabbix-web:
    image: zabbix/zabbix-web-nginx-pgsql:alpine-6.4-latest
    container_name: zabbix-web
    depends_on:
      - pgsql
      - zabbix-server
    environment:
      DB_SERVER_HOST: pgsql
      POSTGRES_USER: zabbix_user
      POSTGRES_PASSWORD: P@ssw0rdSkills
      POSTGRES_DB: zabbix_db
      ZBX_SERVER_HOST: zabbix-server
      PHP_TZ: Europe/Moscow
    ports:
      - "80:8080"
      - "443:8443"
    volumes:
      - ./nginx/ssl:/etc/nginx/ssl
    networks:
      - zabbix-net
    restart: unless-stopped

networks:
  zabbix-net:
    driver: bridge

volumes:
  pgdata:
```
---
```
docker-compose up -d --build
```
