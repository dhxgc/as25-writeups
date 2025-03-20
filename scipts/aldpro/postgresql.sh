#!/bin/bash

sudo apt install postgresql-11
systemctl --now enable postgresql

# Конфигурация
DB_SUPERUSER="postgres"
TMP_SQL_FILE=$(mktemp)  # Создаем временный файл

# Записываем SQL-команды в файл
cat > "$TMP_SQL_FILE" <<EOF
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'zabbix_user') THEN
        CREATE USER zabbix_user WITH PASSWORD 'P@ssw0rdSkills';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'log_user') THEN
        CREATE USER log_user WITH PASSWORD 'P@ssw0rdSkills';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'gitflic_user') THEN
        CREATE USER gitflic_user WITH PASSWORD 'P@ssw0rdSkills';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'superadmin') THEN
        CREATE USER superadmin WITH PASSWORD 'P@ssw0rdSkills' SUPERUSER;
    END IF;
END \$\$;

-- Создание и настройка БД
CREATE DATABASE zabbix_db;
CREATE DATABASE log_db;
CREATE DATABASE gitflic_db;

ALTER DATABASE zabbix_db OWNER TO zabbix_user;
ALTER DATABASE log_db OWNER TO log_user;
ALTER DATABASE gitflic_db OWNER TO gitflic_user;

REVOKE CONNECT ON DATABASE zabbix_db FROM PUBLIC;
REVOKE CONNECT ON DATABASE log_db FROM PUBLIC;
REVOKE CONNECT ON DATABASE gitflic_db FROM PUBLIC;

GRANT CONNECT ON DATABASE zabbix_db TO zabbix_user;
GRANT CONNECT ON DATABASE log_db TO log_user;
GRANT CONNECT ON DATABASE gitflic_db TO gitflic_user;
EOF

# Выполняем SQL-файл и удаляем его
psql -U "$DB_SUPERUSER" -d postgres -f "$TMP_SQL_FILE"
rm -f "$TMP_SQL_FILE"

echo "Настройка завершена!"
