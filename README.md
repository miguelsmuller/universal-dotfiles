# Dotfiles

## 📄 **Descrição**

Os **dotfiles** são arquivos de configuração que personalizam o comportamento de shells, editores de texto, Git, e outras ferramentas utilizadas no terminal. Ao versioná-los com Git, consigo manter um ambiente de desenvolvimento consistente e facilmente replicável em múltiplas máquinas.


## 📚 **Contexto**

Criamos uma estrutura de gerenciamento de **dotfiles** (arquivos de configuração) utilizando um **repositório bare do Git**. Este repositório gerencia os arquivos diretamente em uma pasta chamada `.universal` no diretório home.

---

#### 🏗️ **Estrutura Atual**

A estrutura atual do projeto é a seguinte:

```
~/
├── .universal-bare-repo/     # Repositório bare
├── .universal/
│   ├── dictionaries/         # Arquivos de dicionário personalizados
│   └── dot-files/            # Scripts e configurações do shell
```

- **`.universal-files-bare-repo`**: Contém o repositório bare do Git, que gerencia os arquivos versionados.
- **`.universal-files/`**: Diretório contendo os arquivos de configuração organizados.

---

#### 🔗  **Alias para Facilitar o Uso**

Criamos o alias `config` para interagir com o repositório bare de maneira simplificada. Ele substitui os comandos longos do Git e permite gerenciar os dotfiles facilmente.

Com isso, comandos como `config add`, `config commit` e `config push` podem ser usados para gerenciar os arquivos de configuração.


**Gerenciamento de Configurações Pessoais com Git**

Este repositório contém minhas configurações personalizadas (`dotfiles`) para diversas ferramentas e ambientes, versionadas com Git para facilitar a sincronização e a consistência entre diferentes máquinas.

## ⚙️ **Pré-requisitos**

Antes de começar, certifique-se de que você possui:

- **Git** instalado. Você pode verificar com:

- **Acesso SSH configurado** para o GitHub (ou outra plataforma Git que você utiliza). Siga as instruções [aqui](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh).

## 🚀 **Configuração em uma Nova Máquina**

Siga os passos abaixo para clonar e configurar os **dotfiles** nesta máquina.

### 1. **Clonar o Repositório Bare**

Abra o terminal e execute o seguinte comando para clonar o repositório bare diretamente no seu diretório home:

```shell
git clone --bare git@github.com:miguelsmuller/universal-dot-files.git $HOME/.universal-bare-repo
```

**O que isso faz:**

- **`git clone --bare`**: Clona o repositório sem criar uma cópia de trabalho dos arquivos.
- **`$HOME/.universal-bare-repo`**: Destino do repositório bare, armazenado em uma pasta oculta no seu diretório home.

### 2. **Criar um Alias para Facilitar o Uso do Git**

Para simplificar o uso do Git com o repositório bare, crie um alias. Adicione a seguinte linha ao final do seu arquivo de configuração do shell (`.zshrc`, `.bashrc`, etc.):

```shell
alias config='/usr/bin/git --git-dir=$HOME/.universal-bare-repo --work-tree=$HOME'
```

Após adicionar o alias, recarregue o shell para que as mudanças tenham efeito:

```shell
source ~/.zshrc
# ou
source ~/.bashrc
```

### 3. **Fazer o Checkout dos Arquivos**

Execute o seguinte comando para extrair os arquivos versionados para os diretórios incluindo o `.universal`:

```shell
config checkout
```

**Possível Problema:**

Se alguns arquivos já existirem no diretório `.universal`, você receberá mensagens de erro indicando conflitos. Para resolver isso:

1. **Mover os Arquivos Conflitantes Temporariamente:**

```shell
mkdir -p ~/backup-dotfiles
mv ~/.universal ~/.backup-dotfiles/
```

2. **Fazer o Checkout Novamente:**

```shell
config checkout
```

### 4. **Configurar o Git para Ignorar Arquivos Não Monitorados**

Para evitar que o Git mostre todos os arquivos do diretório `.universal-files` que não estão sendo versionados, configure o Git para ocultar arquivos não monitorados:

```
config config --local status.showUntrackedFiles no
```

### 5. **Verificar a Restauração dos Dotfiles**

Confirme se os arquivos foram restaurados corretamente:

```shell
ls -la ~/.universal
```

A pasta `.universal` deve estar presente com todos os subdiretórios e arquivos intactos.

### 6. **(Opcional) Limpar Arquivos de Backup**

Após confirmar que tudo está funcionando corretamente, você pode remover os backups dos arquivos conflitantes:

```shell
rm -rf ~/backup-dotfiles
```

## 🔄 **Atualizando os Dotfiles**

Sempre que fizer alterações nos seus arquivos de configuração, siga estes passos para atualizar o repositório:

1. **Adicionar as Mudanças:**

```shell
config add ~/.universal-files/dot-files
config add ~/.universal-files/dictionaries
```

2. **Criar um Commit:**

```shell
config commit -m "Atualizar configurações dos dotfiles"
```

3. **Enviar as Mudanças para o Repositório Remoto:**

```shell
cofig push
```


## 🔒 **Gerenciando Informações Sensíveis**

Evite versionar arquivos que contenham informações sensíveis, como senhas ou chaves de API. Adicione esses arquivos ao `.gitignore`:

```shell
config add ~/.universal/.gitignore
echo ".env" >> ~/.universal/.gitignore
config commit -m "Adicionar .env ao .gitignore"
config push
```

## Outras informações

### Encriptação

Ferramentas como git-crypt permitem criptografar arquivos dentro do repositório.

---

### Force Reset

```shell
config fetch
config reset --hard origin/main
```

- **`checkout`**: Tenta extrair os arquivos versionados, mas pode falhar se houver conflitos ou arquivos existentes que impedem a restauração.
- **`reset --hard`**: Alinha completamente o diretório de trabalho com o repositório remoto, forçando a restauração dos arquivos deletados.

---

### **README.md: Localização Local e no Repositório**

A cada atualização do README.md estamos movendo ele para a $HOME e depois levando de volta para .uninversal
