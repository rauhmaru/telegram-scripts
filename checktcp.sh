#!/bin/bash
# CHECKTCP - Verifica portas TCP
# Raul Liborio, rauhmaru@opensuse.org

Exemplo_err="ERRO NO USO.\nUso: ${0##*/} [host|IP] portas\n\n

EXEMPLOS:\n
 ${0##*/} HOST {1..1024} - Verifica da porta 1 a 2014\n
 ${0##*/} HOST 21 22 23 53 - Verifica da porta 1 a 2014\n"

[ $# -eq "1" ] && echo -e $Exemplo_err  && exit 1

echo "Verificando portas TCP em $1..."

for PORT in $@; do
  (echo >/dev/tcp/${1}/${PORT}) >/dev/null 2>&1 && echo "${PORT} aberta"
done
