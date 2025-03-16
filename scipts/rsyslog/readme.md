# SERVER   
```bash
sudo apt update && sudo apt install -y rsyslog
```
---

`/etc/rsyslog.conf`:
  
   ```
   module(load="imudp")
   input(type="imudp" port="514")

   module(load="imtcp")
   input(type="imtcp" port="514")

   $template RemoteLogs,"/opt/logs/%HOSTNAME%.log"
   if $syslogseverity <= 3 then ?RemoteLogs
   & stop
   ```
---
   ```bash
   sudo mkdir -p /opt/logs
   sudo chmod -R 755 /opt/logs
   ```
---
   ```bash
   sudo systemctl restart rsyslog
   ```
---
`/etc/logrotate.d/bash-history`:
   ```
   /opt/logs/*.log {
       rotate 2
       size 1M
       compress
       missingok
       notifempty
       create 0644 root root
       postrotate
           /usr/lib/rsyslog/rsyslog-rotate
       endscript
   }
   ```
---
   ```bash
   (crontab -l 2>/dev/null; echo "* * * * * /usr/sbin/logrotate -f /etc/logrotate.d/bash-history") | sudo crontab -
   ```
---
   ```bash
   sudo apt install -y nginx openssl
   ```
---
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /etc/ssl/private/logs.atom25.local.key \
     -out /etc/ssl/certs/logs.atom25.local.crt \
     -subj "/CN=logs.atom25.local"
   ```
---
`/etc/nginx/sites-available/logs.conf`:
   ```nginx
   server {
       listen 80;
       server_name logs.atom25.local;
       return 301 https://$host$request_uri;
   }

   server {
       listen 443 ssl;
       server_name logs.atom25.local;

       ssl_certificate /etc/ssl/certs/logs.atom25.local.crt;
       ssl_certificate_key /etc/ssl/private/logs.atom25.local.key;

       root /opt/logs;
       autoindex on;

       access_log /var/log/nginx/logs_access.log;
       error_log /var/log/nginx/logs_error.log;
   }
   ```
---
   ```bash
   sudo ln -s /etc/nginx/sites-available/logs.conf /etc/nginx/sites-enabled/
   sudo nginx -t && sudo systemctl restart nginx
   ```


# CLIENT

`/etc/rsyslog.conf`:
  ```
  *.error @192.168.10.1:514
  ```
---
  ```bash
  sudo systemctl restart rsyslog
  ```
