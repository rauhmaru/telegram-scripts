# telegram-scripts

_Coleção de scripts para o Telegram, para auxílio de tarefas._
Faça do seu telegram um verdadeiro terminal, onde você poderá executar comandos diretamente em seu host!
* Obtenha gráficos do Zabbix
* Execute `ping` para verificar a disponibilidade de sites e hosts
* Consulte os nomes através do `nslookup`
* Veja o valor corrente do dolar
* Verifique se um serviço está disponível checando o status da porta TCP ou UDP
* E muito mais vindo aí!


### Instalação
#### Clone o repositório
```
git clone https://github.com/rauhmaru/telegram-scripts.git
cd telegram-scripts
```
#### Configure o vars.conf

##### [vars.conf](vars.conf)
Onde são armazenadas as variáveis utilizadas pelo [tg-grafico.sh](tg-grafico.sh) e [tg-notifica.sh](tg-notifica.sh), como por exemplo, URL, login, senha, diretório de armazenamento das imagens e cookie.
Observações:
* Seu preenchimento é obrigatório
* O usuário deve possuir acesso ao frontend do Zabbix
* A senha desse usuário não pode conter o caractere ```=``` issue #1


##### [batbot.sh](batbot.sh)
Responsável por executar os scripts no servidor. Através de um bot, ele ouve as requisições e as executa, conforme o comando pré-programado. O comando é executado no terminal do host e seu STDOUT é direcionado para o Telegram.

Link para o projeto: https://github.com/theMiddleBlue/BaTbot


##### [tg-grafico.sh](tg-grafico.sh)
Esse script é executado pelo [batbot](batbot.sh), recebendo o *ITEMID* como parâmetro e retornando um gráfico para o solicitante.

##### [tg-notifica.sh](tg-notifica.sh)
Disparado através das ações das triggers, é quem notifica o usuário.
Adicione esse script no diretório de alertscripts.

[Como configurar alertas no Zabbix](https://www.zabbix.com/documentation/3.0/pt/manual/config/notifications/media/script)

Para identificar qual o seu diretório de Alert Scripts, execute o comando:
```egrep ^AlertScripts /etc/zabbix/zabbix_server.conf```


#### Obtendo gráficos do Zabbix pelo telegram
Para a geração de gráficos, **não** é necessário que os scripts [vars.conf](vars.conf), [tg-grafico.sh](tg-grafico.sh) e [batbot](batbot.sh) estejam no servidor do Zabbix. **Eles podem estar em qualquer host**, portanto que consigam acesso a interface web do Zabbix. As consultas são feitas através do método HTTP POST.

## CONFIGURAÇÃO
Esse procedimento é feito em duas etapas:
### 01 - Configurar o zabbix para que gere as notificações e envie os ITEM ID

#### No Servidor Zabbix
Verifique qual o seu diretório de AlertScriptsPath:

`grep ^AlertScript /etc/zabbix/zabbix_server.conf`

Por exemplo:

```
[root@finarfin tmp]# grep ^AlertScript /etc/zabbix/zabbix_server.conf
AlertScriptsPath=/usr/lib/zabbix/alertscripts
```
Acesse o diretório e baixe os scripts:
```
cd /usr/lib/zabbix/alertscripts
git clone https://github.com/rauhmaru/telegram-scripts.git
mv telegram-scripts/{vars.conf,tg-notifica.sh} .
chmod +x tg-notifica.sh
```

#### No Zabbix Web
##### Crie o tipo de mídia
Logado no Zabbix Server como Super-Administrador, clique em **Administração** > **Tipos de mídias** e depois em **Criar tipo de mídia**.
Defina:
  * **Nome:** telegram
  * **Tipo:** Script
  * **Nome do script:** tg-notifica.sh
  * **Ativo:** sim

##### Crie o usuário telegram
Em **Administração > Usuários**, clique em **Criar usuário**
Na guia Usuário, defina o apelido **telegram**. Fique a vontade com os outros parâmetros. Coloque-o em um grupo que tenha acesso as notificações que deseja emitir. O _Zabbix administrators_ é uma sugestão.
Na guia Mídia, clique em adicionar. Defina:
  * **Tipo:** telegram 
  * **Enviar para:** Esse campo não será usado. Preencha como quiser.
  * **Quando ativo:** Período de notificação. O padrão é 24/7.
  * **Ativo:** Sim

##### Defina as ações
  * Nome: Telegram
  * Na guia **Configuração > Ações**, clique em **Criar ação**
  * Na guia **Ação**, defina o nome **telegram**.
  * No campo **Assunto padrão**, defina:

```*[{TRIGGER.STATUS} - {HOST.NAME}]*```

  * No campo **Mensagem padrão**, defina, por exemplo:
```
{TRIGGER.NAME}
{ITEM.NAME1}: {ITEM.VALUE1}
IP: {HOST.IP}
Verificado às {TIME}, em {EVENT.DATE}
ITEM ID: {ITEM.ID}
```
Recuperação:
* Marque o campo **Mensagem de recuperação**
  * No campo **Assunto de recuperação**, defina:
  
```*[{TRIGGER.STATUS} - {HOST.NAME}]*```

* A mensagem de recuperação deixe igual (se quiser, claro!) a mensagem padrão:
```
{TRIGGER.NAME}
{ITEM.NAME1}: {ITEM.VALUE1}
IP: {HOST.IP}
Verificado às {TIME}, em {EVENT.DATE}
ITEM ID: {ITEM.ID}
```
* Na guia **Ações**, em **Operações da ação**, clique em **Nova**.
defina, em **Detalhes da operação > Enviar para usuários**, clique em **Adicionar** e selecione **telegram** e adicione a ação.

### 02 - Rodar o batbot.sh
Após configurar o seu vars.conf, execute o batbot juntamente com um `nohup`, para que ele permaneça em execução mesmo após o logout de seu usuário. Lembre-se de deixar os scripts invocados pelo batbot.sh em seu diretório, caso contrário, não esqueça de especificar dentro do batbot.sh onde estão esses arquivos.

```
nohup ./batbot.sh &
```


## Scripts adicionais

##### [dolar.sh](dolar.sh)
Retorna o valor corrente do dólar comercial e sua variação do dia.

##### [checktcp.sh](checktcp.sh)
Verifica as portas TCP abertas em um host.
Modo de uso: `checktcp.sh HOST PORTAS`

##### [checkudp.sh](checkudp.sh)
Verifica as portas UDP abertas em um host.
Modo de uso: `checkudp.sh HOST PORTAS`

### Etapas
- [x] Envio de notificações
- [x] Envio de gráficos
- [x] Verificação de nomes com o `nslookup`
- [x] Execução de `ping`
- [x] Execução de portscan (`checktcp.sh` e `checkudp.sh`)
- [ ] Consulta de eventos recentes
- [ ] Consulta de Informações de hosts
- [ ] Ideias!
- [ ] Colaboradores
