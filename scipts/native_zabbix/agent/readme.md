# Порядок действий для развертывания zabbix-агента на Astra linux

```
sudo apt install zabbix-agent
```
---
```
sudo mkdir -p /etc/zabbix/psk
sudo chmod 755 /etc/zabbix/psk
```
---
```
openssl rand -hex 32 | sudo tee /etc/zabbix/psk/zabbix_agent.psk
```
---
```
sudo chown zabbix:zabbix /etc/zabbix/psk/zabbix-agent.psk
sudo chmod 600 /etc/zabbix/psk/zabbix_agent.psk
```
---
```
sudo systemctl restart zabbix-agent
```
---
`/etc/zabbix/zabbix_agentd.conf`:
```
Server=192.168.10.1
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=dc01_psk
TLSPSKFile=/etc/zabbix/psk/zabbix_agent.psk
```
---
В веб-интерфейсе:
```
    Configuration → Hosts → Create host

        Host name: dc-01

        Groups: Linux servers

        IP address: IP_адрес_DC-01

        Templates: Template OS Linux by Zabbix agent

    Encryption:

        PSK identity: dc01_psk

        PSK key: (вставить содержимое файла zabbix_agentd.psk)
```
