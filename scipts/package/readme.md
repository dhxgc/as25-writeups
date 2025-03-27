 - `tree`:
```
.
├── atom25-config
│   ├── DEBIAN
│   │   ├── control
│   │   ├── postinst
│   │   └── prerm
│   └── usr
│       └── share
│           └── doc
│               └── atom25-config
│                   ├── changelog.gz
│                   └── copyright
└── atom25-config.deb
```

 - `changelog` надо заархивировать:
```bash
gzip -9n atom25-config/usr/share/doc/atom25-config/changelog
```

 - собрать, проверить, добавить в реп:
```
dpkg-deb -b atom25-config
lintian atom25-config.deb --no-tag-display-limit
reprepro --ask-passphrase -b /var/www/repo/ includedeb atom25 atom25-config.deb
```