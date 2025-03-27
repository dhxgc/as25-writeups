# Server

Создать папки:
```
sudo mkdir /opt/logs
sudo chmod 755 -R /opt/logs 
```
`Модули раскомментить` +
`/etc/rsyslog.conf`:
```
$template RemoteLogs, "/opt/logs/%HOSTNAME%.log"
if $syslogseverity <= 3 then ?RemoteLogs
& stop

$template RemoteBashLog, "/opt/logs/%HOSTNAME%.log"
:syslogtag, startswith, "bash-history" -?RemoteBashLog
& stop
```

```
sudo systemctl restart rsyslog
```
---
# DC-*, SRV-A:

`/etc/syslog-ng/syslog-ng.conf`:
```
destination d_remote {
    syslog(
        "cloud-mon.atom25.local"
        transport("udp")
        port(514)
    );
};

log {
    source(s_src);
    filter(f_error);
    destination(d_remote);
}
```

```
sudo systemctl restart syslog-ng
```
---
# CLI-*

`/etc/bash.bashrc`:
```bash
if [[ $(groups) =~ "atom25.local"  ]]; then
        trap 'logger -t bash-history "login=${USER} cwd=${PWD} filename=$(which ${BASH_COMMAND}) cmdline=${BASH_COMMAND}"' >
fi
```

`/etc/syslog-ng/syslog-ng.conf`:
```
filter f_bash_history {
    program("bash-history");
};

destination d_rsyslog {
    network("cloud-mon.atom25.local" transport("udp") port(514));
};

log {
    source(s_src);
    filter(f_bash_history);
    destination(d_rsyslog);
};
```

```
sudo systemctl restart syslog-ng
```
