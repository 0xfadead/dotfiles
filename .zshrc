# ========
# ZSH BASE
# ========
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey -e
bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward
bindkey '^R'   fzf-history-search
bindkey '^[[3~' delete-char

# ============
# ZINIT CONFIG
# ============
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d ${ZINIT_HOME} ] && mkdir -p "$(dirname ${ZINIT_HOME})"
[ ! -d ${ZINIT_HOME}/.git ] && git clone --depth=1 --recursive https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

source "${ZINIT_HOME}/zinit.zsh"

# ===========
# ZSH PLUGINS
# ===========
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# ===============
# COMMAND ALIASES
# ===============
alias nv="nvim"

alias ls="exa"
alias l="exa -l"

alias gc="git clone --recursive"
alias gch="git clone --recursive --depth=1"

alias cls="clear"

alias gg="shutdown now"
alias brb="reboot"

# =============
# PROMPT CONFIG
# =============
source "$HOME/.files/zsh/prompt.zsh"
