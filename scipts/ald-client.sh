#!/bin/bash



# 1.8 - AS25 image
# =============================================

# ALD PRO
deb https://dl.astralinux.ru/aldpro/frozen/01/2.4.0 1.8_x86-64 main base

# Репы основные
deb https://dl.astralinux.ru/astra/frozen/1.8_x86-64/1.8.1/repository-main/ 1.8_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.8_x86-64/1.8.1/repository-extended/ 1.8_x86-64 main contrib non-free

# Установка пакетов
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-client

# Установка клиента