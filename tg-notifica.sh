#!/bin/bash
#
# Alertas do zabbix no telegram
# Raul Liborio, rauhmaru@opensuse.org
#
# Carregar as principais variaveis 
. $(dirname "$0")/vars.conf

# Comandos
CURL="curl -s"
CHATID=$( ${CURL} ${TELEGRAM_URL}${GETUPDATE} | awk -F'"chat":{"id":' END'{print $2}' | sed 's/,.*//' )
MENSAGEM=$1

# Envio de mensagens de texto
${CURL} ${TELEGRAM_URL}${SENDMESSAGE} -F "chat_id=${CHATID}" -F "text=${MENSAGEM}" 
