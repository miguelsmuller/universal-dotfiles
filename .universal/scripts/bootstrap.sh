#!/usr/bin/env bash

# Instala os dotfiles em uma máquina nova.
# Os arquivos continuam na home (~), onde o sistema e os aplicativos os procuram.
# O histórico do Git fica separado em ~/.universal-bare-repo.

# Para o script quando algo inesperado acontece, em vez de continuar parcialmente:
# -e: um comando falhou; -u: uma variável usada não existe;
# pipefail: uma etapa de um comando com "|" falhou.
set -euo pipefail

# Endereço e branch usados normalmente. Quem precisar testar outro repositório ou branch
# pode definir UNIVERSAL_REPOSITORY_URL ou UNIVERSAL_BRANCH antes de chamar este script.
readonly REPOSITORY_URL="${UNIVERSAL_REPOSITORY_URL:-git@github.com:miguelsmuller/universal-dotfiles.git}"
readonly GIT_DIR="$HOME/.universal-bare-repo"
readonly WORK_TREE="$HOME"
readonly BRANCH="${UNIVERSAL_BRANCH:-main}"

# Estas variáveis guardam as opções escolhidas na linha de comando.
DRY_RUN=false
BACKUP_CONFLICTS=false

# Um array é uma lista. Esta lista recebe os caminhos que impediriam a instalação.
# Ela só é preenchida ao usar --backup-conflicts.
declare -a conflicts=()

# Mostra a ajuda se o script for chamado sem argumentos.
usage() {
  cat <<'EOF'
Uso: bootstrap.sh [--dry-run] [--backup-conflicts]

  --dry-run           Mostra as ações planejadas sem alterar arquivos.
  --backup-conflicts  Move arquivos que conflitam para uma cópia de segurança antes do checkout.
EOF
}

# No modo --dry-run, mostra o comando que seria usado sem mudar nada.
run() {
  if "$DRY_RUN"; then
    printf '+ '
    printf '%q ' "$@"
    printf '\n'
    return
  fi

  "$@"
}

# Verifica cada opção passada ao executar o script, como --dry-run ou --help.
# Se receber uma opção desconhecida, mostra a ajuda e encerra com erro.
for argument in "$@"; do
  case "$argument" in
    --dry-run) DRY_RUN=true ;;
    --backup-conflicts) BACKUP_CONFLICTS=true ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Opção desconhecida: $argument" >&2
      usage >&2
      exit 1
      ;;
  esac
done

# Verifica se o Git está disponível antes de continuar.
if ! command -v git >/dev/null 2>&1; then
  echo "Git não está instalado." >&2
  exit 1
fi

# Se essa pasta já existir, confirma que ela realmente é o repositório bare esperado.
if [ -e "$GIT_DIR" ] && ! git --git-dir="$GIT_DIR" rev-parse --is-bare-repository >/dev/null 2>&1; then
  echo "Já existe algo em $GIT_DIR, mas não é um repositório bare válido." >&2
  exit 1
fi

# Em uma máquina nova, baixa somente o histórico do Git.
# Os arquivos da configuração só serão colocados na home mais adiante, no checkout.
if [ ! -e "$GIT_DIR" ]; then
  run git clone --bare "$REPOSITORY_URL" "$GIT_DIR"
else
  echo "Reutilizando o repositório bare existente em $GIT_DIR"
fi

if "$DRY_RUN"; then
  echo "O checkout será interrompido se encontrar arquivos existentes em conflito."
  echo "Nenhum arquivo será substituído automaticamente."
  exit 0
fi

# Esta função faz o Git usar o histórico em ~/.universal-bare-repo
# e aplicar os arquivos diretamente na home (~).
config_git() {
  command git --git-dir="$GIT_DIR" --work-tree="$WORK_TREE" "$@"
}

# Busca a versão mais recente do repositório antes de instalar os arquivos.
config_git fetch origin

backup_dir=""

# Função que adiciona um arquivo ou pasta à lista de conflitos.
add_conflict() {
  local candidate="$1"
  local conflict

  # Se uma pasta já está na lista, não é preciso incluir cada arquivo dentro dela.
  for conflict in "${conflicts[@]-}"; do
    [ -n "$conflict" ] || continue
    if [ "$candidate" = "$conflict" ] || [[ "$candidate" == "$conflict"/* ]]; then
      return
    fi
  done

  conflicts+=("$candidate")
}

# Função que encontra arquivos ou pastas em conflito entre o repositório e a home.
find_conflicts() {
  local relative_path target parent

  conflicts=()

  # Pede ao Git a lista de todos os arquivos versionados na branch escolhida.
  # O -z faz a lista funcionar mesmo se algum nome de arquivo tiver espaços.
  while IFS= read -r -d '' relative_path; do
    target="$WORK_TREE/$relative_path"

    if [ -e "$target" ] || [ -L "$target" ]; then
      add_conflict "$target"
      continue
    fi

    # Também verifica se uma pasta necessária está bloqueada por um arquivo.
    # Exemplo: ~/.config é um arquivo, mas o repositório precisa criar ~/.config/nvim.
    parent=$(dirname "$target")
    while [ "$parent" != "$WORK_TREE" ]; do
      if [ -L "$parent" ] || { [ -e "$parent" ] && [ ! -d "$parent" ]; }; then
        add_conflict "$parent"
        break
      fi
      parent=$(dirname "$parent")
    done
  done < <(config_git ls-tree -r -z --name-only "$BRANCH")
}

# Função que faz backup dos arquivos ou pastas em conflito, movendo-os para uma pasta de backup.
backup_conflicts() {
  local conflict relative_path destination

  find_conflicts

  if [ -z "${conflicts[0]-}" ]; then
    return
  fi

  # Cria uma pasta de backup com data e hora, para não misturar instalações diferentes.
  # Os arquivos mantêm a mesma estrutura de pastas dentro desse backup.
  backup_dir="$HOME/.universal-backup/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_dir"

  echo "Arquivos existentes em conflito serão movidos para $backup_dir:"
  for conflict in "${conflicts[@]-}"; do
    [ -n "$conflict" ] || continue
    relative_path="${conflict#"$WORK_TREE"/}"
    printf '  %s\n' "$relative_path"
  done

  for conflict in "${conflicts[@]-}"; do
    [ -n "$conflict" ] || continue
    relative_path="${conflict#"$WORK_TREE"/}"
    destination="$backup_dir/$relative_path"
    mkdir -p "$(dirname "$destination")"
    mv "$conflict" "$destination"
  done
}

# Arquivos existentes só são movidos se --backup-conflicts foi informado.
# Sem essa opção, o Git para a instalação sem substituir nem mover nada.
if "$BACKUP_CONFLICTS"; then
  backup_conflicts
fi

if ! config_git checkout "$BRANCH"; then
  cat >&2 <<'EOF'

O Git encontrou arquivos existentes que entrariam em conflito.
Nenhum arquivo foi substituído. Faça uma cópia de segurança dos arquivos indicados pelo Git e execute o instalador novamente.
Para deixar o instalador criar essa cópia automaticamente, use --backup-conflicts.
EOF

  if [ -n "$backup_dir" ]; then
    echo "A cópia de segurança criada em $backup_dir foi preservada." >&2
  fi
  exit 1
fi

# A home tem muitos arquivos pessoais que não pertencem a este repositório.
# Esta configuração impede que eles apareçam todos ao executar "config status".
config_git config --local status.showUntrackedFiles no

# Alguns dados do Git podem variar entre computadores, como identidade ou chave de assinatura.
# O hostname é o nome técnico da máquina e escolhe qual arquivo local será usado.
machine_name=$(hostname)
machine_config="$HOME/.universal/machines/git/.gitconfig.local.$machine_name"
local_gitconfig="$HOME/.gitconfig.local"

if [ -f "$machine_config" ]; then
  if [ ! -e "$local_gitconfig" ]; then
    cp "$machine_config" "$local_gitconfig"
    echo "Aplicada a configuração local de Git para $machine_name."
  elif cmp -s "$machine_config" "$local_gitconfig"; then
    echo "A configuração local de Git para $machine_name já está atualizada."
  else
    echo "Não substituí $local_gitconfig porque ele já existe e é diferente." >&2
    echo "Revise $machine_config e copie-o manualmente se desejar atualizá-lo." >&2
  fi
else
  echo "Não há uma configuração local de Git para $machine_name."
fi

echo "Instalação concluída. Abra um novo terminal ou execute source ~/.zshrc."
