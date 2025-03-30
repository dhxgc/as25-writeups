# 103 VLAN немного иначе по ипам роутеров!!!

# `RTR1`

### VIF
```
set interfaces ethernet eth0 vif 100 address '10.250.100.253/24'
set interfaces ethernet eth0 vif 200 address '10.250.200.253/24
```

### VRRP
```
set high-availability vrrp group VLAN100 interface 'eth0.100'
set high-availability vrrp group VLAN100 virtual-address '10.250.100.254/24' 
set high-availability vrrp group VLAN100 vrid '100' 
set high-availability vrrp group VLAN100 priority '150'
```
```
set high-availability vrrp group VLAN200 interface 'eth0.200'
set high-availability vrrp group VLAN200 virtual-address '10.250.200.254/24'
set high-availability vrrp group VLAN200 vrid '200'
set high-availability vrrp group VLAN200 priority '150'
```

### NAT
```
set nat source rule 100 outbound-interface 'eth1' (внешний)
set nat source rule 100 source address '10.250.0.0/16' (можно не всю сетку)
set nat source rule 100 translation address 'masquerade'
```

### DHCP (на всякий)
Для обоих роутеров (активный будет обрабатывать запросы):
```
set service dhcp-server shared-network-name VLAN200 subnet 10.250.200.0/24 range 10.250.200.100 to 10.250.200.200
set service dhcp-server shared-network-name VLAN200 subnet 10.250.200.0/24 default-router '10.250.200.254'
```

# `RTR2`

### VIF
```
set interfaces ethernet eth0 vif 100 address '10.250.100.252/24'
set interfaces ethernet eth0 vif 200 address '10.250.200.252/24'
```

### VRRP
```
set high-availability vrrp group VLAN100 interface 'eth0.100'
set high-availability vrrp group VLAN100 virtual-address '10.250.100.254/24'
set high-availability vrrp group VLAN100 vrid '100'
set high-availability vrrp group VLAN100 priority '100'
set high-availability vrrp group VLAN100 preempt 'true'
```
```
set high-availability vrrp group VLAN200 interface 'eth0.200'
set high-availability vrrp group VLAN200 virtual-address '10.250.100.254/24'
set high-availability vrrp group VLAN200 vrid '200'
set high-availability vrrp group VLAN200 priority '100'
set high-availability vrrp group VLAN200 preempt 'true'
```

### NAT
```
set nat source rule 200 outbound-interface 'eth1' (внешний)
set nat source rule 200 source address '10.250.0.0/16' (можно не всю сетку)
set nat source rule 200 translation address 'masquerade'
```
