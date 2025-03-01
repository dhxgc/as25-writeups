# Вопросы:
 - Должен ли анонсироваться COD?
 - Откуда качать пакеты программ (с files.atom25.ru или откуда-то еще)?
 - PI адреса только у ZVIRT?
 - Почему к SW123 заходит `vlan 300`, а по таску должен идти `native`?
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
# Общая информация:
- [Настройка вланов на коммутаторах huawei + сравнение с cisco](https://habr.com/ru/articles/153401/)
