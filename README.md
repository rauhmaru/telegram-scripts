# telegram-scripts

##Coleção de scripts para o Telegram, para auxílio de tarefas.

#### batbot.sh
Responsável por executar os scripts no servidor. Através de um bot, ele ouve as requisições e as executa, conforme o comando pré-programado. O comando é executado no terminal do host e seu STDOUT é direcionado para o Telegram.

Link para o projeto: https://github.com/theMiddleBlue/BaTbot


#### vars.conf
Onde são armazenadas as variáveis utilizadas pelo [tg-grafico.sh](https://github.com/rauhmaru/telegram-scripts/blob/master/tg-grafico.sh) e [tg-notifica.sh](https://github.com/rauhmaru/telegram-scripts/blob/master/tg-notifica.sh), como por exemplo, URL, login, senha, diretório de armazenamento das imagens e cookie.
Observações:
* Seu preenchimento é obrigatório
* O usuário deve possuir acesso ao frontend do Zabbix
* A senha desse usuário não pode conter o caractere ```=``` issue#1

#### tg-grafico.sh
Esse script é executado pelo [batbot](https://github.com/rauhmaru/telegram-scripts/blob/master/batbot.sh), recebendo o *ITEMID* como parâmetro e retornando um gráfico para o solicitante.


#### tg-notifica.sh
Disparado através das ações das triggers, é quem notifica o usuário.
Adicione esse script no diretório de alertscripts.

```egrep ^AlertScripts /etc/zabbix/zabbix_server.conf```


## Geração de gráficos
Para a geração de gráficos, não é necessário que os scripts estejam no servidor do Zabbix. Eles podem estar em qualquer host, portanto que consigam acesso a interface web do Zabbix. As consultas são feitas através do método HTTP POST e o usuário que 

## Etapas
- [x] Envio de notificações
- [x] Envio de gráficos
- [x] Verificação de nomes com o ```nslookup```
- [x] Execução de ```ping```
- [ ] Consulta de eventos recentes
- [ ] Consulta de Informações de hosts
- [ ] Ideias!
- [ ] Colaboradores
