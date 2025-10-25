export PATH="$HOME/.local/bin:$PATH"


# PYENV FOR NONINTERACTIVE LOGIN SHELLS (SSH)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
else
    echo "[WARN] pyenv não encontrado. Pulei inicialização do PYENV."
fi

# FROM LOGGI DEV ONBOARDING
export LOGGI_OPS=/opt/loggi/ops
export PATH=${LOGGI_OPS}/ansible/bin:$PATH
