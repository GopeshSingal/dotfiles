# Ensure extended globbing is on for advanced file matching
setopt EXTENDED_GLOB

# Context-aware paths
ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}"

# History Configuration
HISTFILE="$ZSH_CONFIG_DIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# --------------------------------------------------------------------
# Completion Initialization
# --------------------------------------------------------------------
autoload -Uz compinit
if [[ -n $ZSH_CONFIG_DIR/.zcompdump(#qN.m-1) ]]; then
    compinit -C -d "$ZSH_CONFIG_DIR/.zcompdump"
else
    compinit -d "$ZSH_CONFIG_DIR/.zcompdump"
fi

# --------------------------------------------------------------------
# Plugin Management
# --------------------------------------------------------------------
_plugins_txt="$ZSH_CONFIG_DIR/.zsh_plugins.txt"
_plugins_zsh="$ZSH_CONFIG_DIR/.zsh_plugins.zsh"

if [[ ! -f "$_plugins_zsh" || "$_plugins_txt" -nt "$_plugins_zsh" ]]; then
    ANTIDOTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
    if [[ ! -d $ANTIDOTE_DIR ]]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
    fi
    source "$ANTIDOTE_DIR/antidote.zsh"

    # Force Antidote to natively zcompile everything it downloads
    zstyle ':antidote:*' zcompile 'yes'

    # Generate the ultra-fast static file inside a safe subshell
    (antidote bundle < "$_plugins_txt" > "$_plugins_zsh")
fi

source "$_plugins_zsh"

# --------------------------------------------------------------------
# fzf-tab Fine-Tuning
# --------------------------------------------------------------------
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no

if command -v eza &> /dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
elif command -v ls &> /dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
fi

# --------------------------------------------------------------------
# External Tools
# --------------------------------------------------------------------
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# --------------------------------------------------------------------
# Non-Blocking Asynchronous Auto-Compilation
# --------------------------------------------------------------------
if [[ -f "$ZSH_CONFIG_DIR/.zshrc" ]]; then
    (autoload -U zrecompile && zrecompile -q "$ZSH_CONFIG_DIR/.zshrc" &!)
fi
