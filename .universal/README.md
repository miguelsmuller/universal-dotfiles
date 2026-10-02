# Universal Dotfiles

Configurações pessoais compartilhadas entre computadores. Este repositório mantém os arquivos que os programas usam na home e os recursos de manutenção em `~/.universal`.

## Como funciona

Este é um repositório Git *bare*: ele guarda o histórico e a conexão com o remoto em `~/.universal-bare-repo`, mas usa `$HOME` como área de trabalho. Por isso, arquivos como `~/.zshrc`, `~/.gitconfig` e `~/.config/nvim` permanecem onde o macOS e os aplicativos os procuram.

`~/.universal` organiza os arquivos auxiliares que também fazem parte da configuração, como scripts, arquivos do shell, dicionários, serviços e ajustes por computador.

## Estrutura

```text
~/
├── .universal-bare-repo/              # Histórico Git e remoto do repositório
├── .zshrc                             # Configuração ativa do Zsh
├── .zprofile                          # Configuração ativa de login do Zsh
├── .bashrc                            # Configuração ativa do Bash
├── .profile                           # Configuração genérica de login
├── .gitconfig                         # Configuração base ativa do Git
├── .config/
│   ├── nvim/                          # Configuração ativa do Neovim
│   ├── terminator/config              # Configuração ativa do Terminator
│   └── zed/settings.json              # Configuração ativa do Zed
└── .universal/
    ├── README.md                      # Manual desta estrutura
    ├── dictionaries/                  # Dicionários compartilhados
    ├── dot-files/                     # Arquivos carregados pelo shell
    ├── machines/
    │   └── git/                       # Configurações locais do Git por computador
    ├── scripts/                       # Scripts de manutenção
    └── services/                      # Serviços auxiliares locais
```

## Pré-requisitos

- Git instalado (`git --version`).
- Chave SSH cadastrada na conta do GitHub usada para acessar o repositório.

## Instalação automática em uma máquina nova

O instalador cria ou reutiliza o repositório bare, aplica os arquivos rastreados, configura o `status` e tenta aplicar o `gitconfig` específico da máquina.

O modo padrão é seguro: se um arquivo já existente impedir a instalação, ele para sem substituir nada. Para uma máquina que já possui configurações próprias, use `--backup-conflicts`. Essa opção move somente os arquivos que conflitam para `~/.universal-backup/` com data e hora, preservando a estrutura das pastas, e depois aplica os dotfiles.

Primeiro, veja o que será feito:

```shell
curl -fsSL https://raw.githubusercontent.com/miguelsmuller/universal-dotfiles/main/.universal/scripts/bootstrap.sh | bash -s -- --dry-run
```

Para instalar:

```shell
curl -fsSL https://raw.githubusercontent.com/miguelsmuller/universal-dotfiles/main/.universal/scripts/bootstrap.sh | bash
```

Para instalar e criar cópia de segurança automática dos conflitos:

```shell
curl -fsSL https://raw.githubusercontent.com/miguelsmuller/universal-dotfiles/main/.universal/scripts/bootstrap.sh | bash -s -- --backup-conflicts
```

Depois, revise `~/.universal-backup/` e incorpore manualmente ao repositório qualquer ajuste antigo que ainda queira manter.

O comando baixa e executa o instalador publicado no repositório. Leia o script antes de executá-lo se estiver usando uma máquina de terceiros ou quiser revisar cada passo.

## Alternativa manual: recuperação e auditoria

Esta não é a instalação recomendada. Use o instalador automático acima na maioria dos casos.

Siga estes passos somente se quiser revisar e executar cada etapa manualmente, se o instalador automático não puder ser usado ou se precisar recuperar uma instalação. Este processo não cria cópia automática dos conflitos: faça a cópia dos arquivos indicados pelo Git antes de continuar.

1. Clone o repositório bare:

   ```shell
   git clone --bare git@github.com:miguelsmuller/universal-dotfiles.git "$HOME/.universal-bare-repo"
   ```

2. Crie a função `config` apenas neste terminal:

   ```shell
   config() {
     command git --git-dir="$HOME/.universal-bare-repo" --work-tree="$HOME" "$@"
   }
   ```

3. Aplique os arquivos rastreados:

   ```shell
   config checkout
   ```

   Se houver conflitos, faça cópia de segurança apenas dos arquivos que o Git indicar antes de tentar novamente. Como alternativa, use a instalação automática com `--backup-conflicts`.

4. Oculte os arquivos não rastreados. Isso evita que a home inteira apareça no `config status`:

   ```shell
   config config --local status.showUntrackedFiles no
   ```

5. Aplique a configuração local de Git da máquina atual e carregue o shell configurado:

   ```shell
   bash "$HOME/.universal/scripts/update_gitconfig_local.sh"
   source ~/.zshrc
   ```

## Configurações por máquina

Arquivos que variam entre computadores ficam em `~/.universal/machines/git/`. O comando `config-update` procura o arquivo cujo nome corresponde ao resultado de `hostname` e o copia para `~/.gitconfig.local`.

Exemplo:

```text
~/.universal/machines/git/.gitconfig.local.MacBook-Air.local
```

## Comando `config`

No Zsh, a função `config` executa Git usando o repositório bare e a home como área de trabalho:

```shell
config() {
  command git --git-dir="$HOME/.universal-bare-repo" --work-tree="$HOME" "$@"
}
```

Exemplos de uso:

```shell
config status
config add ~/.zshrc ~/.universal/dot-files
config commit -m "Atualizar configuração do shell"
config push
```

O repositório oculta arquivos não rastreados para evitar que a home inteira apareça no `status`.

## Atualização diária

Adicione somente os arquivos que deseja versionar. Alguns caminhos comuns são:

```shell
config add ~/.zshrc ~/.zprofile ~/.gitconfig
config add ~/.universal/dot-files ~/.universal/dictionaries
config add ~/.config/nvim ~/.config/zed ~/.config/terminator
config commit -m "Descrever a alteração"
config push
```

## O que versionar

Versione configurações portáveis e revisadas, como as do shell, Git, Neovim, Zed e Terminator. Evite caches, históricos, bancos locais e credenciais de ferramentas como Google Cloud e GitHub Copilot.

Nunca adicione senhas, tokens ou credenciais ao Git. Quando um arquivo precisar de valores privados, mantenha um exemplo versionado e o arquivo real fora do repositório. Se algum conteúdo sensível realmente precisar ser versionado, avalie usar `git-crypt` antes de adicioná-lo.

## Neovim

`~/.config/nvim` é mantido como um Git subtree do projeto [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Para atualizá-lo:

```shell
config fetch nvim
config subtree pull --prefix=.config/nvim nvim main --squash -m "Atualizar kickstart.nvim"
config push
```

## Recuperação

Para revisar mudanças, use `config status` e `config diff`.

Em último caso, para descartar todas as alterações locais e deixar a configuração igual à branch `main` remota:

```shell
config fetch origin
config reset --hard origin/main
```

Esse comando descarta alterações locais. Revise os arquivos e crie uma cópia de segurança antes de usá-lo.
