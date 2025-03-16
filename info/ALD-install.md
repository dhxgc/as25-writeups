Начать установку ALD:
```bash
/opt/rbta/aldpro/mp/bin/aldpro-server-install.sh -d example.org -n hostname -p 'P@ssw0rd' --no-reboot --ip 127.0.0.1
```

Начать установку ALD с подсистемами:
```bash
sudo /opt/rbta/aldpro/mp/bin/aldpro-server-install.sh -d branch.atom25.local -n dc-b -p 'P@ssw0rd' --ip 192.168.122.52 --no-reboot --setup_syncer --setup_gc
```

