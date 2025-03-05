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
- Если не удаляется - сделать интерфейс manual (убирается ip):
```
set network interface adapter port0 iface-mode manual
``` 
- Создать маршрут по умолчанию:
```
create network gateway interface port2 ip <ip> enabled on default on
```
