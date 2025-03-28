# Вопросы:
 - Должны ли анонсироваться `PI`?
 - Как достучаться до `atom24.ru`/`atom25.ru`?
 - Что в итоге с `ZVIRT`/`Libvirt`?
 - Правильно ли мы понимаем, что в MAIN'е - NativeVLAN - 300? Или же смотреть не на топологию, а на таблицу? Хотя по моему мнению, врет таблица, и в DC `Native` - 666, а в MAIN `Native`- 300

# Мануалы:
- [Типовые варианты настройки VLAN на устройствах huawei (`Задания 3 и 5`), сначала - коммутаторы, потом добавляются роутеры](https://support.huawei.com/enterprise/ru/doc/EDOC1000069520/b699322c/typical-vlan-configuration)
- [BGP Debian](https://docs.frrouting.org/en/latest/bgp.html)
- [VRRP/HSRP `Vyos` Only VPN](https://docs.vyos.io/en/latest/configuration/highavailability/index.html)
- [VRRP/HSRP `FRR`](https://docs.frrouting.org/en/latest/vrrp.html)
- [LACP Debian](https://wiki.debian.org/Bonding#Shutdown_.2F_Unconfigure_Existing_Interfaces)
- [Deepseek про OVS в main](https://github.com/dhxgc/as25-writeups/blob/main/ai/OVS-main.md)
- [Установка часового пояса/указание `NTP` сервера для синхронизации на `AR, USG`](https://admin-gu.ru/device/huawei/nastrojka-ntp-timezone-daty-i-vremeni-na-huawei)
- [`NTP на Astra` (все возможные службы + настройка часового пояса через timedatectl + клиенты астры)](https://wiki.astralinux.ru/pages/viewpage.action?pageId=27361687)
- [`BIND9 + BIND9_DLZ на Astra`](https://wiki.astralinux.ru/pages/viewpage.action?pageId=27362248)
- [`GRE + OSPF на Huawei`](https://support.huawei.com/enterprise/en/doc/EDOC0100585934/55280d46/example-for-configuring-a-gre-tunnel-and-ospf-on-the-tunnel-to-implement-interworking#EN-US_TASK_0177893299)
- [`NAT на huawei`](https://support.huawei.com/enterprise/en/doc/EDOC1100034071/e96c0933/example-for-configuring-nat)
- [`NAT vyos`](https://docs.vyos.io/en/latest/configuration/nat/index.html)
- [GitFlic на Астре](https://docs.gitflic.ru/setup/gitflic_app/astra_setup_and_start/?ysclid=m7qozzn18s415352616#postgresql)
- [Свой репозиторий на Астре](https://wiki.astralinux.ru/pages/viewpage.action?pageId=3277393&ysclid=m7qp7rnp4q112377109)
- (SSH: Huawei (AR/USG), VyOS, FRR, Windows - надо найти)[]

# Общая информация:
- [Настройка вланов на коммутаторах huawei + сравнение с cisco](https://habr.com/ru/articles/153401/)
- [Usergate документация](https://static.usergate.com/manuals/ugutm/7/ru/NGFW-7-ru.html#)


