> Почитать если тупняк - [доки от астры](https://wiki.astralinux.ru/pages/viewpage.action?pageId=105976211#id-%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D0%B0%D1%8F%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D0%B0%D1%8F%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%B0NFS%D1%81%D0%B0%D1%83%D1%82%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D0%B5%D0%B9Kerberos%D0%B2%D0%B4%D0%BE%D0%BC%D0%B5%D0%BD%D0%B5FreeIPA-%D0%9E%D0%BF%D0%B8%D1%81%D0%B0%D0%BD%D0%B8%D0%B5%D1%81%D1%82%D0%B5%D0%BD%D0%B4%D0%B0)

## srv-a:

```bash
sudo apt install nfs-kernel-server

sudo sed -i 's/^[[:space:]]*NEED_SVCGSSD[[:space:]]*=.*/NEED_SVCGSSD="yes"/' /etc/default/nfs-kernel-server
sudo sed -i 's/^[[:space:]]*NEED_GSSD[[:space:]]*=.*/NEED_GSSD=yes/' /etc/default/nfs-common
sudo sed -i 's/^[[:space:]]*NEED_IDMAPD[[:space:]]*=.*/NEED_IDMAPD=yes/' /etc/default/nfs-common
```

## dc-a:
```bash
ipa service-add nfs/srv-a.office.atom25.local
# Или в вебе зарегать
```

## srv-a:
```bash
# после регистрации службы нужно обновить билет

sudo ipa-getkeytab -s dc-a.office.atom25.local -p nfs/srv-a.office.atom25.local -k /etc/krb5.keytab

sudo systemctl daemon-reload
sudo systemctl restart nfs-kernel-server

sudo mkdir /export
sudo chmod 777 /export
```

 - `/etc/exports`:
```text
/ *(rw,fsid=0,no_subtree_check,sec=krb5:krb5i:krb5p)
/home gss/krb5i(rw,sync,no_subtree_check)
/export *(rw,sync,no_subtree_check,no_root_squash,sec=krb5:krb5i:krb5p)
/profiles /profiles gss/krb5i(rw,sync,no_subtree_check,no_root_squash,sec=krb5:krb5i:krb5p)
```

```bash
# каждый раз после изменения /etc/exports 
sudo exportfs -ra

# Проверка что применилось
sudo showmount -e srv-a
```

## cli-a:
```bash
sudo apt install nfs-common
sudo showmount -e srv-a

sudo sed -i 's/^[[:space:]]*NEED_GSSD[[:space:]]*=.*/NEED_SVCGSSD="yes"/' /etc/default/nfs-common
sudo sed -i 's/^[[:space:]]*NEED_IDMAPD[[:space:]]*=.*/NEED_IDMAPD="yes"/' /etc/default/nfs-common
```

> и теперь ебаная хуйня непонятная:
>
> на серваке в мануале тоже надо регать службы у юзеров - `kinit admin; ipa service-add nfs/cli-a.office.atom25.local`, но я это не делал, ровно как и следующий шаг
>
> и уже у клиента сделать - `sudo kinit admin; sudo ipa-getkeytab -s dc-a.office.atom25.local -p nfs/cli-a.office.atom25.local -k /etc/krb5.keytab`
>

# Перемещаемые профили:

## dc-a:
```bash
# для 1 пользователя, глобально в вебе не выставляется
ipa user-mod nfs_profile --homedir=/mnt/nfs/home

# посмотреть
ipa user-show nfs_profile --all

# обязательно!!!!!!!!!!!
ipactl restart
```

## cli-a
```bash
# /etc/fstab, с первого раза оно не очухалось, зашел только со второго, довольно долго
srv-a.office.atom25.local:/profiles       /mnt/nfs/home   nfs     defaults        0       0
```