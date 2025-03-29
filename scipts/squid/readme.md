# ПЕРЕДЕЛАТЬ НА PAM

Команды:
```bash
apt install squid apache2-utils
htpasswd /etc/squid/passwd ivan
htpasswd /etc/squid/passwd aleksey
chown proxy:proxy /etc/squid/passwd 
chmod 440 /etc/squid/passwd
```

 - `/etc/squid/squid.conf`:
```conf
acl localnet src 10.0.0.0/8             # RFC 1918 local private network (LAN)
acl localnet src 172.16.0.0/12          # RFC 1918 local private network (LAN)
acl localnet src 192.168.0.0/16         # RFC 1918 local private network (LAN)
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
include /etc/squid/conf.d/*.conf
http_port 3128
coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm proxy
acl BLOCKED dstdomain '/etc/squid/blocklist'
acl SPEED dstdomain '/etc/squid/blocklist-2'
acl AUTH proxy_auth REQUIRED
acl ACL_ALEKSEY proxy_auth aleksey
acl BLOCKPNG urlpath_regex -i \.mp4 \.png
http_access deny BLOCKED
http_access allow SPEED AUTH
http_access allow all !BLOCKED !SPEED
http_access deny all
delay_pools 1
delay_class 1 4
delay_access 1 allow ACL_ALEKSEY SPEED BLOCKPNG
delay_access 1 deny all
delay_parameters 1 -1/-1 -1/-1 -1/-1 80/80
```

На клиенте:

 - `/etc/firefox/syspref.js`:
```js
pref("network.proxy.http", "srv-a.office.atom25.local");
pref("network.proxy.http_port", 3128);
pref("network.proxy.ssl", "srv-a.office.atom25.local");
pref("network.proxy.ssl_port", 3128);
pref("network.proxy.type", 1);
```