#!/bin/bash

echo "Добавление репозиториев для обновления:"
ASTRA_VERSION=$(cat /etc/astra_version)

if [[ "${ASTRA_VERSION}" =~ "1.7" ]]; 
then
    cp /etc/apt/sources.list{,.old}
    echo "deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/uu/2/repository-base 1.7_x86-64 main contrib non-free" > /etc/apt/sources.list
    echo "deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/uu/2/repository-extended 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
elif [[ "${ASTRA_VERSION}" =~ "1.8" ]];
then
    cp /etc/apt/sources.list{,.old}
    echo "deb https://dl.astralinux.ru/astra/frozen/1.8_x86-64/1.8.1/repository-main 1.8_x86-64 main contrib non-free" > /etc/apt/sources.list
    echo "deb https://dl.astralinux.ru/astra/frozen/1.8_x86-64/1.8.1/repository-extended 1.8_x86-64 main contrib non-free" >> /etc/apt/sources.list
fi

# deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.5/uu/1/repository-base 1.7_x86-64 main contrib non-free
# deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.5/uu/1/repository-extended 1.7_x86-64 main contrib non-free


sudo apt update
