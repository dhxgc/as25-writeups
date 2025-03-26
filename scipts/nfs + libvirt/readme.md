> Репозитории выставил `frozen 1.7.5`

 - Установка:
```bash
apt update && apt install bridge-utils virt-manager nfs-common -y
```

 - Добавить администратора в группу, иначе не заведется 
```
adduser administrator libvirt-admin
mkdir /nfs
```

 - `/etc/fstab`
```
10.0.10.201:/mnt/nfs/nfs/       /nfs/   nfs     defaults        0       0
```

 - Смонтировать:
```bash
systemctl daemon-reload
mount -a
```

 - Скачать `astra_kvm`:
```bash
cd /nfs/
wget https://files.atom25.ru/images/astra_kvm.qcow2
```

 - Добавить тачку в автозагрузку:
```bash
sudo virsh autostart CLOUD-INFRA
```