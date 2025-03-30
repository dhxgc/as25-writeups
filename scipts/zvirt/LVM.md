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
sudo vgcreate vg_str /dev/sdb1 /dev/sdc1 /dev/sdd1
```

---

Логические тома (LV):
##### a. **HostedStorage** (62 Гб, Mirror)
```bash
sudo lvcreate --type mirror -m 1 -L 31G -n HostedStorage vg_str
```
- `-m 1` — зеркалирование на 2 диска.

##### b. **VMNFS** (75 Гб, Striped)
```bash
sudo lvcreate -i 2 -I 64 -L 75G -n VMNFS vg_str
```
- `-i 2` — чередование по 2 дискам.

##### c. **VMISCSI** (75 Гб, Striped)
```bash
sudo lvcreate -i 2 -I 64 -L 75G -n VMISCSI vg_str
```

##### d. **Data** (оставшееся место, Linear)
```bash
sudo lvcreate -l 100%FREE -n Data vg_str
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

#### **7. Форматирование и монтирование**
Для каждого том:
```bash
sudo mkfs.ext4 /dev/vg_str/HostedStorage
sudo mkdir /mnt/HostedStorage
sudo mount /dev/vg_str/HostedStorage /mnt/HostedStorage
```
Аналогично для `VMNFS`, `VMISCSI`, `Data`.
