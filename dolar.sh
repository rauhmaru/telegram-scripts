#!/bin/bash
# Consulta o valor do dolar hoje
DOLAR=$( curl -s "http://api.dolarhoje.com" )

echo "Dolar: R$ ${DOLAR}"
