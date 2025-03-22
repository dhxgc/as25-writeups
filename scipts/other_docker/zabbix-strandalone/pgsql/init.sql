CREATE USER superadmin WITH SUPERUSER CREATEDB LOGIN PASSWORD 'P@ssw0rdSkills';

CREATE USER zabbix_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE USER gitflic_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';
CREATE USER kc_user WITH LOGIN PASSWORD 'P@ssw0rdSkills';

CREATE DATABASE zabbix_db OWNER zabbix_user;
CREATE DATABASE gitflic_db OWNER gitflic_user;
CREATE DATABASE kc_db OWNER kc_user;
