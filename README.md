# Dotfiles

## 📄 Descrição

Os **dotfiles** são arquivos de configuração que personalizam shells, editores, Git e outras ferramentas de terminal. Mantê‑los versionados em um repositório Git garante que meu ambiente de desenvolvimento seja idêntico em qualquer máquina com apenas alguns comandos.

## 📚 Contexto

Utilizo um **repositório *bare*** localizado em `~/.universal-bare-repo`. Diferentemente de um clone normal, o repositório *bare* não possui cópia de trabalho; ele rastreia diretamente os arquivos do meu **work tree** (`$HOME`). Os arquivos em si vivem dentro da pasta `~/.universal/`, organizada por tipo.

## 🏗️ Estrutura

```text
~/
├── .universal-bare-repo/     # Repositório Git bare
├── .universal/
│   ├── dictionaries/         # Dicionários personalizados
│   └── dot-files/            # Scripts e configurações de shell
├── .config/
│   └── nvim/                 # Configuração do NVim
└── *                         # Demais arquivos do $HOME
```

* `~/.universal-bare-repo`: repositório Git *bare*.
* `~/.universal/`: pasta onde os dotfiles residem (gerenciada pelo bare).
* Demais arquivos em `$HOME` podem ser rastreados conforme a necessidade.

## ⚙️ Pré‑requisitos

* **Git** instalado (`git --version`).
* **Chave SSH** cadastrada no GitHub (veja as instruções em [https://docs.github.com/pt/authentication/connecting-to-github-with-ssh](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh)).

## 🔗 Alias `config`

Para facilitar o uso do Git com o bare, adicione o alias abaixo ao final do `~/.zshrc` ou `~/.bashrc`:

```shell
alias config='/usr/bin/git --git-dir=$HOME/.universal-bare-repo --work-tree=$HOME'
```

Recarregue o shell para aplicar as alterações:

```shell
source ~/.zshrc   # ou
source ~/.bashrc
```

---

## 🚀 Primeira instalação em uma máquina nova

1. **Clonar o repositório bare**

   ```shell
   git clone --bare git@github.com:miguelsmuller/universal-dot-files.git $HOME/.universal-bare-repo
   ```

2. **Adicionar o alias** (veja seção anterior) e recarregar o shell.

3. **Extrair os arquivos**

   ```shell
   config checkout
   ```

   **Conflitos?** Se arquivos já existirem:

   ```shell
   mkdir -p ~/backup-dotfiles
   mv ~/.universal ~/backup-dotfiles/
   config checkout
   ```

4. **Esconder arquivos não rastreados**

   ```shell
   config config --local status.showUntrackedFiles no
   ```

5. **Conferir resultado**

   ```shell
   ls -la ~/.universal
   ```

6. **(Opcional) Remover backups**

   ```shell
   rm -rf ~/backup-dotfiles
   ```

---

## 🔄 Mantendo os dotfiles atualizados

```shell
# 1. Adicionar mudanças
config add ~/.universal/dot-files
config add ~/.universal/dictionaries
config add .config/nvim

# 2. Commitar
config commit -m 'Atualizar configurações dos dotfiles'

# 3. Enviar para o GitHub
config push
```

---

## 🪄 Atualizando o *git subtree* do Kickstart.nvim

A pasta `~/.config/nvim` **não** é um submódulo; ela é um ***git subtree*** que aponta para [nvim‑lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Assim todos os arquivos ficam visíveis no GitHub, e eu posso atualizar com:

```bash
# Buscar novidades do repositório upstream
config fetch nvim

# Mesclar na pasta .config/nvim
config subtree pull --prefix=.config/nvim nvim main --squash -m "Update kickstart.nvim"

# Enviar o novo commit
config push
```

---

## 🔒 Informações sensíveis

Nunca versiono senhas, tokens ou arquivos `.env`. Para ignorá‑los:

```shell
echo '.env' >> ~/.universal/.gitignore
config add ~/.universal/.gitignore
config commit -m 'Adicionar .env ao .gitignore'
config push
```

Quando necessário, utilizo [**git‑crypt**](https://github.com/AGWA/git-crypt) para criptografar conteúdos sigilosos.

---

## 💣 Force reset (use com cuidado)

```shell
config fetch
config reset --hard origin/main
```

* `checkout`: tenta aplicar mudanças, mas pode falhar se houver conflitos.
* `reset --hard`: sincroniza 100 % com o remoto, sobrescrevendo arquivos locais.

---

## 📍 Localização do `README.md`

Durante edições, copio o `README.md` para `$HOME` para facilitar ajustes e depois o devolvo à pasta correta (`~/.universal`). O histórico do Git registra esses movimentos.

---

Boa hackeada! 🚀
