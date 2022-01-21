# status-changer

Esse repositorio concentra todos os codigos referentes ao desafio técnico da pagar.me de SRE. Esse repositorio e seus modulos foram criados por [Pedro Espíndula](https://espindula.me).

## Setup do ambiente

Se você estiver vendo esse README, provavelmente você já baixou o repositório e já o desempacotou. Se de alguma forma você ainda não o fez, faça.

1. Instale o [Terrraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (Versão: v1.0.4)
2. Instale a [AWS Cli](https://aws.amazon.com/pt/cli/). Para maiores informações visite a seguinte [documentação](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
3. Configure a AWS CLI com o seguinte comando

```shell
$ aws configure
```

## Executando

### Terraform com S3

Primeiro de tudo, precisamos configurar o nosso backend para que tanto nos como também a máquina do Github actions possam acessar o estado do terraform. Para isso foi criada uma infraestrutura que sobe um Bucket S3 e uma tabela no DynamoDB que irão servir de backend para o nosso terraform. Para fazer o deploy, siga os seguintes passos:

1. Entre na pasta `infra/remote-tfstate/terraform` com o seguinte comando:

```bash
$ cd infra/remote-tfstate/terraform/
```

2. Inicialize as dependencias do terraform

```bash
$ terraform init
```

3. Aplique a definição terraform:

```bash
$ terraform apply -auto-approve
```

4. Volte para a raiz do projeto:

```bash
$ cd ../../../
```

### Repositório no Github

1. Crie um repositório no Github

2. Adicione uma nova remote ao seu repositório local com o seguinte comando:

```
git remote add origin git@github.com:<NOME_DO_USUARIO>/<NOME_DO_REPOSITORIO>.git
```

> Modifique o <NOME_DO_USUARIO> com seu nome do usuário do Github e o <NOME_DO_REPOSITORIO> com o nome do repositório criado

### Usuário do Github na AWS

Configurado nosso backend e tendo nosso repositório, precisaremos agora dar acesso ao Github Actions a nossa cloud na AWS. Para isso, criaremos um usuário IAM que terá acesso para fazer o deploy da nossa infraestrutura com terraform e fazer o upload das imagens no ECR. Para isso, siga os seguintes passos:

1. Entre na pasta `infra/remote-tfstate/terraform` com o seguinte comando:

```bash
$ cd infra/remote-tfstate/terraform/
```

2. Inicialize as dependencias do terraform

```bash
$ terraform init
```

3. Aplique a definição terraform:

```bash
$ terraform apply -auto-approve
```

4. Obtenha as chaves de acesso do usuário IAM:

```bash
$ terraform output -json
```

5. Configure o secret no Github de `AWS_ACCESS_KEY_ID` a partir do valor do `github_access_key` exibido no output do terraform.

> Caso tenha duvidas em como adicionar um secret, visite essa [documentação](https://docs.github.com/pt/actions/security-guides/encrypted-secrets)

6. Faça o mesmo para o secret de `AWS_SECRET_ACCESS_KEY` a partir do valor do `github_secret_key` exibido no output do terraform.

7. Volte para a raiz do projeto:

```bash
$ cd ../../../
```

### Cluster ECS

Dado que já configuramos nosso Github e nosso Backend, podemos tanto fazer o push do estado atual do nosso repositório, como também podemos fazer todo o processo de deploy manual. Como somos preguiçosos, vamos apenas fazer o push do repositório e ativar o workflow.

1. Faça o push do repositório:

```bash
$ git push origin main
```

2. Ative o workflow manualmente na interface do github.

> Em caso de dúvidas, siga a seguinte [documentação](https://docs.github.com/pt/actions/managing-workflow-runs/manually-running-a-workflow)
