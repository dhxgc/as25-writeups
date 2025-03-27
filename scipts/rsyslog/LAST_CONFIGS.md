# Server

Создать папки:
```
mkdir /opt/logs
chmod 755 -R /opt/logs 
```
`Модули раскомментить`
`/etc/rsyslog.conf`:
```
$template RemoteLogs, "/opt/logs/%HOSTNAME%-%PROGRAMNAME%.log"
if $syslogseverity <= 3 then ?RemoteLogs
& stop

$template RemoteBashLog, "/opt/logs/%HOSTNAME%.log"
:syslogtag, isequal, "bash-history" -?RemoteBashLog
& stop
```

# DC-*, SRV-A:
`/etc/rsyslog.conf`:
```
*.error @cloud-mon.atom25.local:514
```
# CLI-*

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

`/etc/bash.bashrc`:
```bash
if [[ $(groups) =~ "atom25.local"  ]]; then
        trap 'logger -t bash-history "login=${USER} cwd=${PWD} filename=$(which ${BASH_COMMAND}) cmdline=${BASH_COMMAND}"' >
fi
```
