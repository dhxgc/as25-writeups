sudo astra-freeipa-client -U

sudo apt purge 'aldpro*' 'freeipa*' 'sssd*' 'krb5*'
sudo apt autoremove --purge

sudo rm -rf /var/lib/sss/pubconf/krb5.include.d/
sudo rm -rf /var/lib/sss/
sudo rm -rf /etc/sssd/
sudo rm -rf /etc/krb5.conf.d/
sudo rm -rf /opt/rbta/aldpro/
sudo rm -rf /etc/syslog-ng/aldpro/
sudo rm -rf /srv/aldpro-salt/minion.d/
sudo rm -rf /srv/aldpro-salt/config/
sudo rm -rf /var/lib/certmonger/