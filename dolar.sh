#!/bin/bash
# Consulta o valor do dolar
# Raul Liborio, rauhmaru@opensuse.org
DOLAR=/tmp/dolar
CURL=$(curl -s "http://developers.agenciaideias.com.br/cotacoes/json" > ${DOLAR})
echo "$(cat ${DOLAR} | awk -F'"' '{ print $12": " $16}')"
echo "$(cat ${DOLAR} | awk -F'"' '{ print $18": " $20}')"
