 - Репозитории:
```
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-base 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-extended 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/aldpro/frozen/01/2.4.0 1.7_x86-64 main base
```

Установка:
```bash
# Обновление до 1.7.6
sudo apt update && sudo apt dist-upgrade -y

# Пакеты - DC-A + DC-B
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q syslog-ng-mod-astra aldpro-mp aldpro-gc aldpro-syncer

# DC-A
sudo /opt/rbta/aldpro/mp/bin/aldpro-server-install.sh -d office.atom25.local -n dc-a -p 'P@ssw0rd' --ip 10.0.20.100 --no-reboot --setup_syncer --setup_gc

# DC-B
sudo /opt/rbta/aldpro/mp/bin/aldpro-server-install.sh -d branch.atom25.local -n dc-b -p 'P@ssw0rd' --ip 10.0.30.2 --no-reboot --setup_syncer --setup_gc
```

 - На клиенте:
```
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-extended 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-base 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/aldpro/frozen/01/2.4.0 1.7_x86-64 main base
```

 - Установка на клиенте
```bash
sudo apt update
sudo apt dist-upgrade

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-client

sudo /opt/rbta/aldpro/client/bin/aldpro-client-installer --domain office.atom25.local --account admin --password 'P@ssw0rd' --host srv-a --gui --force
```

