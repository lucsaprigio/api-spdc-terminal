# ApiSpdc - Serviço de Descompactação e Envio de XMLs

O ApiSpdc é uma API construída em Delphi projetada para automatizar a extração e o envio de Notas Fiscais Eletrônicas. O foco principal deste serviço é consultar notas armazenadas de forma comprimida no banco de dados, descompactar esses arquivos (usando ZLib), organizá-los em um pacote .zip e enviá-los por e-mail (usando ACBrMail) para o cliente solicitado.

# Estrutura do Projeto (MVC)

O projeto foi organizado utilizando os princípios do MVC para manter as responsabilidades separadas:

/Routers: Define os endpoints da API. É onde o Horse escuta a rota /api/xml.

/Controllers: O TControllerNotas recebe o JSON da requisição, extrai os parâmetros e delega a execução para a camada de serviço rodar em uma Thread Secundária, liberando a API para responder imediatamente.

/Services: O coração da aplicação.

O Service.Descompactador faz a mágica do ZLib.

O Service.ACBrMail.Email encapsula a lógica de envio SMTP.

O Service.NotasXml orquestra tudo: busca, descompacta, zipa e envia.

/Models/DAO: Responsável exclusivo por conversar com o banco de dados via FireDAC e extrair as chaves e os BLOBs.

/Infra: Contém as configurações baseadas em Interfaces para conexão de banco (Infra.Connection), logs de terminal (Infra.Logger) e o contrato de e-mail (Infra.Email).

# Configuração

Ao executar a aplicação pela primeira vez, um arquivo config.ini será gerado automaticamente na mesma pasta do executável. Ele armazena as conexões com o banco de dados e as credenciais de SMTP do ACBrMail:

```ini
    [BancoConfig]
    DriverID=FB
    Server=127.0.0.1
    Port=3050
    Database=C:\Caminho\BancoPrincipal.fdb
    User=sysdba
    Password=masterkey

    [BancoXml]
    ServerXml=127.0.0.1
    DatabaseXml=C:\Caminho\BancoXml.fdb
    PortXml=3050
    UserXml=sysdba
    PasswordXml=masterkey

    [SMTP]
    MailHost=smtp.gmail.com
    MailPort=587
    MailUsername=seu_email@gmail.com
    MailPassword=sua_senha_de_app
```

# Endpoint

A API roda nativamente na porta 9000.

POST /api/xml
Inicia o processo assíncrono de localização, descompactação e envio dos arquivos.

Corpo da Requisição (JSON):

```json
{
  "dataIni": "01/01/2024",
  "dataFin": "31/01/2024",
  "cnpj": "12345678000199",
  "emailDestino": "cliente@email.com"
} 
```