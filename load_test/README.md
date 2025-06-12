# load-test

Essa pasta se refere ao teste de carga para a API do status_changer. A definição desse teste de carga se encontra em `script.js` e ele tem suporte a docker.

## Execução

1. Para executa-lo, primeiro execute a API de acordo com o guia de execução. [Link para o guia](https://github.com/pedroespindula/status_changer/tree/main/api#executando)

2. Copie as variaveis de ambiente:

```sh
$ cp .env.example .env
```

3. Rode o `docker-compose` na raiz do projeto com o arquivo de configuração principal:

```sh
$ docker-compose up
```
