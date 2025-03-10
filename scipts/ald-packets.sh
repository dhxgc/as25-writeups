#!/bin/bash

echo -e "Установить ALD PRO?\nПри выборе no - будут сделаны подготовительные действия [yes/no]:"
read -p "> " INSTALL_ALD

if [[ "${INSTALL_ALD}" == "no" ]];
then

    astra-modeswitch set 2
    astra-mic-control enable

    echo "deb https://dl.astralinux.ru/aldpro/frozen/01/2.4.0 1.7_x86-64 main base" > /etc/apt/sources.list.d/aldpro.list

    echo "1) Hostname"
    echo "2) Hosts"
    echo "3) Exit"

elif [[ "${INSTALL_ALD}" == "yes" ]];
then
    sudo apt update

    sudo apt install -y -q fly-all-main
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-mp

fi