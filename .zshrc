### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk


export PATH=/sbin:${PATH}

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000
setopt inc_append_history
setopt share_history
setopt hist_reduce_blanks
setopt histignorealldups
# 行頭がスペースのコマンドは history に残さない
setopt HIST_IGNORE_SPACE

# Emacs キーバインド
bindkey -e

# color
autoload -Uz colors && colors
export LSCOLORS=Gxfxcxdxbxegedabagacad

# select-word-style
# https://github.com/zsh-users/zsh/blob/cb59dfb3a6f6cce414c5b852c138d5f6bea6d563/Functions/Zle/select-word-style#L76-L81
autoload -Uz select-word-style && select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|."
zstyle ':zle:*' word-style unspecified

# alias
alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'

# history timestamp
alias h='fc -lt '%F %T' 1'

alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# ghq
alias g='cd $(ghq root)/$(ghq list | peco)'

# nvim
alias vim='nvim'

# completion
zinit ice wait'!0'
zinit light zsh-users/zsh-completions

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

bindkey '^[[Z' reverse-menu-complete

# kubectl
if type kubectl > /dev/null; then
  source <(kubectl completion zsh)
fi

# helm
if type helm > /dev/null; then
  source <(helm completion zsh)
fi

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# beep を無効
setopt no_beep

# 環境変数を補完
setopt AUTO_PARAM_KEYS

# 履歴検索
# https://wiki.archlinux.jp/index.php/Zsh
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# peco
# https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# cdr
# https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^G' peco-cdr

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
PURE_PROMPT_SYMBOL=$


zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light hlissner/zsh-autopair
zinit light olets/zsh-abbr

# https://asdf-vm.com/guide/getting-started.html
ASDF_INIT_FILE="$HOME/.asdf/asdf.sh"
if [ -e ${ASDF_INIT_FILE} ]; then
  . "${ASDF_INIT_FILE}"
  fpath=(${ASDF_DIR}/completions $fpath)
fi

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

if [[ `uname -a` == *WSL2* ]]; then
  # https://github.com/BlackReloaded/wsl2-ssh-pageant
  # === SSH ===
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
    if test -x "$wsl2_ssh_pageant_bin"; then
      (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
    fi
    unset wsl2_ssh_pageant_bin
  fi

  # === GPG ===
  export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
  if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
    rm -rf "$GPG_AGENT_SOCK"
    wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
    if test -x "$wsl2_ssh_pageant_bin"; then
      (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
    fi
    unset wsl2_ssh_pageant_bin
  fi
fi

if [ -e /home/sbdn/.nix-profile/etc/profile.d/nix.sh ]; then . /home/sbdn/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C nomad nomad

complete -o nospace -C vault vault

# 自前設置や
export PATH=$PATH:${HOME}/.local/bin

# last

autoload -Uz compinit && compinit
