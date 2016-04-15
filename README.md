# telegram-scripts

##Coleção de scripts para o Telegram, para auxílio de tarefas.

### batbot.sh
Responsável por executar os scripts no servidor. Através de um bot, ele fica ouvindo as requisições e quando recebe determinado comando pré-programado, o executa no terminal do host, retornando a saída para o Telegram.

### tg-notifica.sh
Disparado através das ações das triggers, é quem notifica o usuário.

### tg-grafico.sh
Esse script é executado pelo batbot, recebendo o ITEMID como parâmetro e retornando um gráfico para o solicitante.

### vars.conf
Onde são armazenadas as variáveis, como por exemplo, URL, login, senha, diretório de armazenamento das imagens e cookie.
