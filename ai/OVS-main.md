Чтобы все настройки (включая IP-адреса) сохранялись после перезагрузки при использовании Open vSwitch (OVS), выполните следующие шаги:

---

### 1. **Установка OVS и базовые настройки (для всех коммутаторов)**
```bash
sudo apt update
sudo apt install -y openvswitch-switch
sudo systemctl enable openvswitch-switch
```

---

### 2. **Настройка агрегации (LACP) и транков**
**На SW1 (активный LACP):**
```bash
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-bond br0 bond0 eth1 eth2 \
    lacp=active \
    bond_mode=balance-tcp

# Настройка транков и Native VLAN
sudo ovs-vsctl set port bond0 vlan_mode=trunk
sudo ovs-vsctl set port bond0 trunks=10,20
sudo ovs-vsctl set port bond0 tag=100  # Native VLAN для управления
```

**На SW2/SW3 (пассивный LACP):**
```bash
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-bond br0 bond0 eth1 \
    lacp=passive \
    bond_mode=balance-tcp

sudo ovs-vsctl set port bond0 vlan_mode=trunk
sudo ovs-vsctl set port bond0 trunks=10,20
sudo ovs-vsctl set port bond0 tag=100
```

---

### 3. **Настройка STP (RSTP)**
**На SW1 (наименьший приоритет):**
```bash
sudo ovs-vsctl set bridge br0 stp_enable=true
sudo ovs-vsctl set bridge br0 rstp_enable=true
sudo ovs-vsctl set bridge br0 other_config:stp-priority=0
```

**На SW2/SW3:**
```bash
sudo ovs-vsctl set bridge br0 stp_enable=true
sudo ovs-vsctl set bridge br0 rstp_enable=true
# Приоритет по умолчанию (32768)
```

---

### 4. **Настройка статического IP (чтобы сохранялся после перезагрузки)**
**Для SW1:**
```bash
sudo nano /etc/network/interfaces.d/br0
```
Добавьте:
```bash
auto br0
iface br0 inet static
    address 192.168.100.1/24  # Пример IP для управления
    gateway 192.168.100.254   # Если нужен шлюз
    dns-nameservers 8.8.8.8
    mtu 9000
```

**Для SW2:**
```bash
address 192.168.100.2/24
```

**Для SW3:**
```bash
address 192.168.100.3/24
```

---

### 5. **Фиксация физических интерфейсов**
Убедитесь, что физические интерфейсы (eth1, eth2) не управляются NetworkManager.  
Отредактируйте основной конфиг:
```bash
sudo nano /etc/network/interfaces
```
Добавьте:
```bash
# Отключаем управление для интерфейсов, используемых в OVS
auto eth1
iface eth1 inet manual

auto eth2
iface eth2 inet manual
```

---

### 6. **Проверка зависимостей служб**
Создайте файл для правильного порядка запуска:
```bash
sudo nano /etc/systemd/system/ovs-netconfig.service
```
Добавьте:
```bash
[Unit]
Description=Pre-configure OVS before network starts
Before=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/ovs-vsctl add-br br0
ExecStart=/usr/bin/ovs-vsctl add-bond br0 bond0 eth1 eth2  # Для SW1
# (Для SW2/SW3 укажите соответствующие интерфейсы)

[Install]
WantedBy=multi-user.target
```

Активируйте службу:
```bash
sudo systemctl enable ovs-netconfig
```

---

### 7. **Сохраните конфигурацию OVS**
```bash
sudo ovs-vsctl save
sudo systemctl restart openvswitch-switch
```

---

### 8. **Перезагрузите систему**
```bash
sudo reboot
```

---

### Проверка после перезагрузки:
1. **Статус OVS:**
   ```bash
   sudo ovs-vsctl show
   ```

2. **IP-адрес:**
   ```bash
   ip addr show br0
   ```

3. **LACP:**
   ```bash
   sudo ovs-appctl bond/show
   ```

4. **STP:**
   ```bash
   sudo ovs-appctl stp/show
   ```

---

### **Ключевые моменты:**
1. **Сохранение IP-адресов:**  
   Настройки IP прописаны в `/etc/network/interfaces.d/br0`, что гарантирует их применение при загрузке.

2. **Управление интерфейсами:**  
   Физические интерфейсы переведены в режим `manual`, чтобы избежать конфликтов с OVS.

3. **Порядок запуска:**  
   Служба `ovs-netconfig` создает мост и бонд до старта сетевых интерфейсов.

4. **Native VLAN:**  
   Указан через `tag=100`, но не добавлен в `trunks`, что соответствует условиям задачи.

Если все шаги выполнены, конфигурация будет полностью рабочей после перезагрузки.
