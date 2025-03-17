sudo apt install docker docker-compose


структура:

zabbix-project/
├── docker-compose.yml
├── pgsql/
│   ├── Dockerfile
│   └── init.sql
└── nginx/
    └── ssl/
        ├── zabbix.crt
        └── zabbix.key

3. Запуск системы
mkdir zabbix-project
cd zabbix-project
mkdir nginx pgsql
touch docker-compose.yml

