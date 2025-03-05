- Войти в конфигурационный режим:
```
configure
```
- Сделать UserGate главным узлом (master):
```
execute install node master
```
 - Сделать UserGate дополнительным узлом (slave):
```
execute install node slave
```
 - Поставить IP на адаптер:
```
set network interface adapter port2 ip-addresses [ 192.168.99.2/24 ]
```
 - Удалить IP с адаптера:
```
delete network interface adapter port2 ip-addresses [ 192.168.99.2/24 ]
```
