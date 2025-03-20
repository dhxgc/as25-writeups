```bash
apt install reprepo nginx
mkdir -p /var/www/repo/conf/
```

 - Сгенерий ключ (1, 4096-4096, 36m, atom25@atom25.local)
```bash
gpg --full-generate-key --expert
```

 - vim /var/www/repo/conf/distibutions
```
Origin: Atom25
Label: Atom25 Repository
Codename: atom25
Architectures: amd64
Components: atom25-apps
Description: Corporate repository
SignWith: C79918E16BB46D56 - вот эта хуйня выводится при создании ключа (или можно на клиенте ключ добавить в доверенные, он выведет номер и скажет что этому ключу не доверяю)
```

 - вывести ключ в файл:
```bash
gpg --armor --export atom25@atom25.local > /home/astra/deb/repo.gpg
```

 - добавить ключ в доверенные (на клиенте):
```bash
apt-key add repo.gpg
```

 - vim /etc/nginx/sites-available/repo
```
server {
        listen 80;
        server_name repo.atom25.local;
        root /var/www/repo;
}
```



 - Дополнительно:
```
gpg --delete-secret-keys atom25
reprepro --ask-passphrase -b /var/www/repo/ includedeb atom25 пакет.deb
reprepro -b /var/www/repo/ list atom25
```