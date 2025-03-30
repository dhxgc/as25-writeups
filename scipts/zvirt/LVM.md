`Проверка метаданных при сбое`:
```
sudo vgscan
sudo vgcfgrestore vg_str
```

`Бэкап метаданных (делать регулярно)`:
```
sudo vgcfgbackup vg_str
```



## PARTED

Для каждого диска (`/dev/sdb`, `/dev/sdc`, `/dev/sdd`):
```bash
sudo parted /dev/sdb
```
В интерактивном режиме:
1. Создать GPT-разметку:
   ```plaintext
   mklabel gpt
   ```
2. Создать раздел на весь диск:
   ```plaintext
   mkpart primary 0% 100%
   ```
3. Установить тип раздела как LVM:
   ```plaintext
   set 1 lvm on
   ```
4. Выйти:
   ```plaintext
   quit
   ```
Аналогично `/dev/sdc` и `/dev/sdd`.

---

## FDISK
Для каждого диска:
```bash
sudo fdisk /dev/sdb
```
1. Создать GPT-таблицу: `g`.
2. Создать раздел: `n` → Enter (все параметры по умолчанию).
3. Изменить тип раздела: `t` → код `31` (Linux LVM в GPT).
4. Сохранить: `w`.

Аналогично`/dev/sdc` и `/dev/sdd`.

---

Физические тома (PV):
```bash
sudo pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1
```

---

Группа томов (VG):
```bash
sudo vgcreate LVM /dev/sdb1 /dev/sdc1 /dev/sdd1
```

---

Логические тома (LV):
##### a. **HostedStorage** (62 Гб, Mirror)
```bash
sudo lvcreate --type mirror -m 1 -L 31G -n HostedStorage LVM
```
- `-m 1` — зеркалирование на 2 диска.

##### b. **VMNFS** (75 Гб, Striped)
```bash
sudo lvcreate -i 2 -I 64 -L 75G -n VMNFS LVM
```
- `-i 2` — чередование по 2 дискам.

##### c. **VMISCSI** (75 Гб, Striped)
```bash
sudo lvcreate -i 2 -I 64 -L 75G -n VMISCSI LVM
```

##### d. **Data** (оставшееся место, Linear)
```bash
sudo lvcreate -l 100%FREE -n Data LVM
```

---

#### **6. Проверка**
- Посмотреть логические тома:
  ```bash
  sudo lvs
  ```
- Посмотреть группу томов:
  ```bash
  sudo vgs
  ```
- Посмотреть физические тома:
  ```bash
  sudo pvs
  ```
---

## Удаление

`Посмотреть + проверка`:
```
sudo vgdisplay LVM
```

`Если требуется`:
```
sudo umount /dev/LVM/HostedStorage
```

`Удаление`:
```
sudo lvremove /dev/LVM/HostedStorage
```

`Изменение размера после удаления`:
```
sudo lvextend -l +100%FREE /dev/LVM/Data
```

`Расширение файловой системы (если она уже была отформатирована)`:
```
sudo resize2fs /dev/LVM/Data  # Для ext4
```

### ФОРМАТИРОВАНИЕ + МОНТИРОВАНИЕ

`Форматирование`:
```
sudo mkfs.ext4 /dev/LVM/HostedStorage
sudo mkfs.ext4 /dev/LVM/VMNFS
sudo mkfs.ext4 /dev/LVM/Data
```
---
```
sudo mkdir -p /mnt/hestorage /mnt/vm-nfs /mnt/Data
```
`/etc/fstab`:
```
/dev/LVM/HostedStorage /mnt/hestorage ext4 defaults 0 0
/dev/LVM/VMNFS /mnt/vm-nfs ext4 defaults 0 0
/dev/LVM/Data /mnt/Data ext4 defaults 0 0
```
```
sudo mount -a
```
---
`NFS`:
```
sudo apt install -y nfs-kernel-server
```
`/etc/exports`:
```
/mnt/hestorage *(rw,sync,no_subtree_check,no_root_squash)
/mnt/vm-nfs *(rw,sync,no_subtree_check,no_root_squash)
```
```
sudo systemctl restart nfs-kernel-server
```
---
`SMB`:
```
sudo apt install -y samba
```
`/etc/samba/smb.conf`:
```
[Data]
  path = /mnt/Data
  valid users = <@DOMAIN\\user> 
  read only = no
  guest ok = no
```
```
sudo systemctl restart smbd
```
---
`iSCSI`:
```
sudo apt install -y targetcli-fb
```
`Пошагово`:
```
/> backstores/block create name=vm-iscsi dev=/dev/LVM/VMISCSI
/> iscsi/ create iqn.2023-08.storage.atom.skills:vm-iscsi
/> iscsi/iqn.2023-08.storage.atom.skills:vm-iscsi/tpg1/luns/ create /backstores/block/vm-iscsi
/> iscsi/iqn.2023-08.storage.atom.skills:vm-iscsi/tpg1/acls/ create iqn.2023-08.client:initiator
/> saveconfig
/> exit
```
```
sudo systemctl restart target
```
---
### Проверка
nfs
```
sudo showmount -e
```
smb
```
testparm 
```
iSCSI
```
sudo targetcli ls
```
