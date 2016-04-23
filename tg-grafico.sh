#!/bn/bash
#
# Graficos do zabbix no telegram
# Raul Liborio, rauhmaru@opensuse.org
#
VERSION=0.2

# Carregar as principais variaveis 
. $(dirname "$0")/vars.conf

#Cria o TMP_DIR
[ ! -d "${TMP_DIR}" ] && (mkdir -p ${TMP_DIR} || TMP_DIR="/tmp")

# Telegram
# Customizacao do gráfico 
# É possível mudar a cor e tipo do gráfico
# drawtype = 0 - linha fina, 1 - preenchido, 2 - linha grossa, 3 - pontilhado, 4 - pontilhado fino, 5 - gradiente
# color = Cor do grafico, em hexadecimal

URL="${ZBX_SERVER}/chart3.php?&width=900&height=200&period=3600&name=${ZBX_ITEMID}&legend=1&items[0][itemid]=${ZBX_ITEMID}&items[0][drawtype]=5&items[0][color]=B173F0"

# Comandos
CURL="curl -s"
CHATID=$( ${CURL} ${TELEGRAM_URL}${GETUPDATE} | awk -F'"chat":{"id":' END'{print $2}' | sed 's/,.*//' )
TO=$1
SUBJECT=$2
BODY=$3
# ** FUNCOES ** #
# Login no Zabbix
login() {
    # Crie um cookie de autenticacao
    ${CURL} --cookie-jar ${TMP_COOKIE} --request POST --data "name=${ZBX_USER}&password=${ZBX_PASS}&enter=Sign%20in" ${ZBX_SERVER}/
}

get_image() {
    # Faz download do grafico em png e o salva em um diretorio temporario
    ${CURL} --cookie ${TMP_COOKIE} --globoff "${URL}" -o ${IMG_NAME}
}


# Funcao de envio de graficos + texto
send_graphs (){
        login
        get_image "${URL}" ${IMG_NAME}
        ${CURL} ${TELEGRAM_URL}/sendPhoto -F "chat_id=${CHATID}" -F "photo=@${IMG_NAME}" -F "caption=${SUBJECT}
${TG_TEXT}" &> /dev/null
}

# -- *** -- 
# Verifique se os graficos serao enviados sempre ou quando solicitado:
echo "{BODY}" | grep -q "::graficos::"

# Caso verdade, chame a funcao de envio de graficos e saia
# Caso falso, envie apenas o grafico se for solicitado
if [ $? -eq "0" ] ; then
        TG_TEXT=$( echo "${BODY}" | grep -v '::graficos::'; echo "--" )
        ZBX_ITEMID="$( echo "${BODY}" | awk -F': ' /ITEM\ ID/'{ print $NF}')"
        URL="${ZBX_SERVER}/chart3.php?&width=900&height=200&period=3600&name=${ZBX_ITEMID}&legend=1&items[0][itemid]=${ZBX_ITEMID}&items[0][drawtype]=5&items[0][color]=B173F0"
        send_graphs
        exit 0
fi

#Caso esteja definido o marcador ::texto::, envie a notificacao por texto
echo "{BODY}" | grep -q "::texto::"
if [ $? -eq "0" ] ; then
        TG_TEXT=$( echo "${BODY}" | grep -v '::texto::'; echo "--" )
        send_txt
        exit 0
fi

# Envio de graficos por solicitacao
login
get_image "${URL}" ${IMG_NAME}
${CURL} ${TELEGRAM_URL}/sendPhoto -F "chat_id=${CHATID}" -F "photo=@${IMG_NAME}" -F "caption=$2
$3" &> /dev/null
# rm -f ${IMG_NAME}
