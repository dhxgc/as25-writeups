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

`/etc/bash.bashrc`:
```bash
if [[ $(groups) =~ "atom25.local"  ]]; then
        trap 'logger -n cloud-mon.atom25.local -t bash-history "login=${USER} cwd=${PWD} filename=$(which ${BASH_COMMAND}) cmdline=${BASH_COMMAND}"' DEBUG
fi
```
