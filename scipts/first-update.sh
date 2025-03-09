#!/bin/bash

echo "Добавление репозиториев для обновления:"

cp /etc/apt/sources.list{,.1-7-5}
echo "deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/uu/2/repository-base 1.7_x86-64 main contrib non-free" > /etc/apt/sources.list
echo "deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/uu/2/repository-extended 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list

sudo apt update