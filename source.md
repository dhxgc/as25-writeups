# Вопросы:
 - Должен ли анонсироваться COD?
 - Откуда качать пакеты программ (с files.atom25.ru или откуда-то еще)?
 - PI адреса только у ZVIRT?
 - Почему к SW123 заходит `vlan 300`, а по таску должен идти `native`?
 - 
# Мануалы:

- [Типовые варианты настройки VLAN на устройствах huawei (`Задания 3 и 5`), сначала - коммутаторы, потом добавляются роутеры](https://support.huawei.com/enterprise/ru/doc/EDOC1000069520/b699322c/typical-vlan-configuration)
- [BGP Debian](https://docs.frrouting.org/en/latest/bgp.html)
- [VRRP/HSRP `Vyos` Only VPN](https://docs.vyos.io/en/latest/configuration/highavailability/index.html)
- [VRRP/HSRP `FRR`](https://docs.frrouting.org/en/latest/vrrp.html)
- [LACP Debian](https://wiki.debian.org/Bonding#Shutdown_.2F_Unconfigure_Existing_Interfaces)

# Общая информация:
- Настройка вланов на коммутаторах huawei + сравнение с cisco: https://habr.com/ru/articles/153401/
- 

---

# Таски с SW1/2/3:

Чтобы настройки сохранились после перезагрузки, нужно учесть особенности Debian. Вот исправленная инструкция:

### 1. Настройка агрегации с LACP (с сохранением)
**На SW1 (активный режим):**
```bash
sudo nano /etc/network/interfaces
```
Добавьте:
```bash
# Bonding интерфейс
auto bond0
iface bond0 inet manual
    bond-mode 4
    bond-miimon 100
    bond-lacp-rate 1
    bond-slaves eth1 eth2
    bond-xmit-hash-policy layer3+4
    bond-lacp-active on  # Явно включаем активный режим
```

**На SW2/SW3 (пассивный режим):**
```bash
sudo nano /etc/network/interfaces
```
```bash
auto bond0
iface bond0 inet manual
    bond-mode 4
    bond-miimon 100
    bond-lacp-rate 1
    bond-slaves eth1
    bond-xmit-hash-policy layer3+4
    bond-lacp-active off  # Пассивный режим
```

### 2. Настройка транков и VLAN (с сохранением)
```bash
# Установите пакеты и загрузите модули ядра
sudo apt install -y vlan bridge-utils
sudo sh -c "echo '8021q' >> /etc/modules"
sudo sh -c "echo 'bonding' >> /etc/modules"

# Настройте VLAN на bond0
sudo nano /etc/network/interfaces
```
Добавьте:
```bash
# Транки VLAN (пример для VLAN 10,20)
auto bond0.10
iface bond0.10 inet manual
    vlan-raw-device bond0

auto bond0.20
iface bond0.20 inet manual
    vlan-raw-device bond0

# Native VLAN для управления (не добавляется в транк)
auto bond0
iface bond0 inet static
    address 192.168.100.1  # Пример IP для SW1
    netmask 255.255.255.0
    mtu 9000
```

### 3. Настройка STP (с сохранением)
```bash
# Создайте мост с постоянными настройками
sudo nano /etc/network/interfaces
```
Добавьте:
```bash
# Мост с RSTP
auto br0
iface br0 inet manual
    bridge-ports bond0.10 bond0.20
    bridge-stp on
    bridge-vlan-aware yes
    bridge-vids 10,20
    bridge-pvid 100  # Native VLAN
    bridge-ageing 300
    bridge-fd 0
    bridge-maxwait 0
    # Приоритет только на SW1
    bridge-hello 2
    bridge-maxage 20
    bridge-forward-delay 15
    bridge-priority 24576  # Только для SW1! На SW2/SW3 оставьте 32768
```

### 4. Дополнительные меры для сохранения настроек
```bash
# Для работы RSTP (802.1w)
sudo nano /etc/sysctl.conf
```
Добавьте:
```bash
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
net.bridge.stp_enabled = 1
```

### 5. Применить изменения
```bash
# Перезагрузить модули ядра
sudo systemctl restart systemd-modules-load

# Перезапустить сеть
sudo systemctl restart networking

# Проверить состояние после перезагрузки
sudo reboot now
```

### Проверка после перезагрузки:
1. Агрегация:
```bash
cat /proc/net/bonding/bond0 | grep -E "Mode|LACP rate|Active"
```

2. VLAN:
```bash
ip -d link show bond0 | grep vlan
```

3. STP:
```bash
brctl showstp br0 | grep -i "protocol|priority"
```

### Ключевые моменты:
1. Все настройки внесены в `/etc/network/interfaces` (основной конфигурационный файл)
2. Модули ядра добавлены в `/etc/modules`
3. Использована нативная конфигурация моста через интерфейс `br0`
4. STP приоритет задан явно в конфигурации моста
5. Отключена фильтрация bridge-netfilter через sysctl

Эти настройки сохранятся после любой перезагрузки, так как используют штатные механизмы конфигурации сети в Debian.