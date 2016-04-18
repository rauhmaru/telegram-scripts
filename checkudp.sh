#!/bin/bash
# CHECKUDP - Verifica portas UDP
# Raul Liborio, rauhmaru@opensuse.org
# Uso:
# checkudp.sh HOST PORTAS
# 
# EXEMPLOS:
# checkudp.sh HOST {1..1024} - Verifica da porta 1 a 2014
# checkudp.sh HOST 21 22 23 53 - Verifica da porta 1 a 2014

echo "Verificando portas UDP em $1..."
for PORT in $@;
do
  (echo >/dev/udp/${1}/${PORT}) >/dev/null 2>&1 && echo "${PORT} aberta"
done
