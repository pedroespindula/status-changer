# API

A API se trata de uma simples API REST feita em flask que apenas reproduz o `status_code` que foi mandado para ela através do corpo da requisição.

## Executando

### Ambiente de desenvolvimento

1. Copie as variaveis de ambiente:

```sh
$ cp .env.example .env
```

2. Atualize as variaveis de ambiente vazias com as os valores corretos (IDs, chaves e segredos)
3. Rode o `docker-compose` na raiz do projeto com o arquivo de configuração principal:

```sh
$ docker-compose up
```

### Testes

Para executar os testes utilize o seguinte comando

```sh
$ docker-compose run api python -m pytest src
```

### Linter

Para executar o linter utilize o seguinte comando

```sh
$ docker-compose run api python -m flake8
```

## Rotas

> **Versão**: 1.0.0
>
> **URL Base**: https://status_changer.espindula.me/

## Descrição

Retorna um objeto informando o status_code passado.

## URI

```URI
 GET /
```

## Descrição da resposta

```STATUS
status: 200 OK
```

```json
{
  "servico": "Nome do serviço utilizado (Constante - status_changer)",
  "iniciado_em": "Timestamp de quando o serviço foi iniciado",
  "status_code": "O status code atual do servico",
  "timestamp": "Timestamp de quando os dados foram gerados, ou seja, de quando a requisição foi feita"
}
```

## Exemplo

### Comando

```bash
curl https://status_changer.espindula.me/
```

### Resposta

```json
{
  "iniciado_em": "2022-01-18 20:10:57.497402",
  "servico": "status_changer",
  "status_code": 200,
  "timestamp": "2022-01-18 20:11:13.674573"
}
```

1. Copie as variaveis de ambiente:

```sh
$ cp .env.example .env
```

2. Atualize as variaveis de ambiente vazias com as os valores corretos (IDs, chaves e segredos)
3. Rode o `docker-compose` na raiz do projeto com o arquivo de configuração principal:

```sh
$ docker-compose up
```

## Rotas

> **Versão**: 1.0.0
>
> **URL Base**: https://status_changer.espindula.me/

## Descrição

Retorna um objeto informando o status_code passado.

## URI

```URI
 GET /
```

## Descrição da resposta

```STATUS
status: 200 OK
```

```json
{
  "servico": "Nome do serviço utilizado (Constante - status_changer)",
  "iniciado_em": "Timestamp de quando o serviço foi iniciado",
  "status_code": "O status code atual do servico",
  "timestamp": "Timestamp de quando os dados foram gerados, ou seja, de quando a requisição foi feita"
}
```

## Exemplo

### Comando

```bash
curl https://status_changer.espindula.me/
```

### Resposta

```json
{
  "iniciado_em": "2022-01-18 20:10:57.497402",
  "servico": "status_changer",
  "status_code": 200,
  "timestamp": "2022-01-18 20:11:13.674573"
}
```
