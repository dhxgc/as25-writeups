**Настройка OSPF over GRE между Huawei и VyOS:**

---

### **1. Настройка GRE-туннеля**

**1.1 На Huawei (пример для AR серии):**
```bash
system-view

# Создание туннельного интерфейса
interface Tunnel 0/0/1
 description GRE to VyOS
 ip address 10.0.0.1 255.255.255.252  # Локальный IP туннеля
 tunnel-protocol gre
 source GigabitEthernet0/0/1          # Интерфейс, через который идет туннель
 destination 203.0.113.2              # Публичный IP VyOS
```

**1.2 На VyOS:**
```bash
configure

# Создание GRE-интерфейса
set interfaces tunnel tun0 address 10.0.0.2/30
set interfaces tunnel tun0 encapsulation gre
set interfaces tunnel tun0 local-ip 203.0.113.2     # Публичный IP VyOS
set interfaces tunnel tun0 remote-ip 198.51.100.1   # Публичный IP Huawei
commit
```

---

### **2. Проверка связности через туннель**
- На Huawei:
  ```bash
  ping 10.0.0.2
  ```
- На VyOS:
  ```bash
  ping 10.0.0.1
  ```

---

### **3. Настройка OSPF**

**3.1 На Huawei:**
```bash
ospf 1 router-id 1.1.1.1
 area 0.0.0.0
  network 10.0.0.0 0.0.0.3    # Анонсировать сеть туннеля
  network 192.168.1.0 0.0.0.255 # Анонсировать другие сети (если нужно)
```

**3.2 На VyOS:**
```bash
configure
set protocols ospf router-id 2.2.2.2
set protocols ospf area 0 network 10.0.0.0/30
set protocols ospf area 0 network 192.168.2.0/24  # Другие сети
commit
```

---

### **4. Важные нюансы**

- **MTU и MSS:**
  - На Huawei:
    ```bash
    interface Tunnel 0/0/1
     mtu 1400
     tcp adjust-mss 1360
    ```
  - На VyOS:
    ```bash
    set interfaces tunnel tun0 mtu 1400
    set interfaces tunnel tun0 adjust-mss 1360
    ```

- **Статическая маршрутизация (если нет BGP/IKE):**
  - На Huawei:
    ```bash
    ip route-static 203.0.113.2 32 GigabitEthernet0/0/1
    ```
  - На VyOS:
    ```bash
    set protocols static route 198.51.100.1/32 next-hop 203.0.113.1
    ```

---

### **5. Проверка работы OSPF**

**На Huawei:**
```bash
display ospf peer          # Проверка соседей
display ip routing-table  # Проверка маршрутов через туннель
```

**На VyOS:**
```bash
show ip ospf neighbor     # Статус соседства
show ip route ospf        # Маршруты OSPF
```

---

### **6. Пример итоговой конфигурации**

**Huawei:**
```bash
interface Tunnel0/0/1
 ip address 10.0.0.1 255.255.255.252
 tunnel-protocol gre
 source GigabitEthernet0/0/1
 destination 203.0.113.2
 mtu 1400

ospf 1 router-id 1.1.1.1
 area 0.0.0.0
  network 10.0.0.0 0.0.0.3
```

**VyOS:**
```bash
interfaces {
  tunnel tun0 {
    address 10.0.0.2/30
    encapsulation gre
    local-ip 203.0.113.2
    remote-ip 198.51.100.1
    mtu 1400
  }
}

protocols {
  ospf {
    router-id 2.2.2.2
    area 0 {
      network 10.0.0.0/30
    }
  }
}
```

---

**Если OSPF-соседство не устанавливается:**
1. Убедитесь, что туннель активен (`display interface Tunnel 0/0/1` на Huawei, `show interfaces` на VyOS).
2. Проверьте, что OSPF-пакеты не блокируются фаерволом.
3. Сравните **Area ID**, **Hello/Dead таймеры** и **аутентификацию** на обоих устройствах.
