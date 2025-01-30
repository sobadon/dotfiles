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

# brew
if [[ `uname -a` == *Darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # dircolors, etc ...
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
fi

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

export LSCOLORS=Gxfxcxdxbxegedabagacad

eval "$(dircolors -b)"
# ディレクトリ 青色つらいので
export LS_COLORS=$LS_COLORS:'di=01;36:'
autoload -Uz colors && colors

# select-word-style
# https://github.com/zsh-users/zsh/blob/cb59dfb3a6f6cce414c5b852c138d5f6bea6d563/Functions/Zle/select-word-style#L76-L81
autoload -Uz select-word-style && select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|."
zstyle ':zle:*' word-style unspecified

# alias
alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'

if type nvim > /dev/null; then
    alias vi='nvim'
    alias vim='nvim'
fi

# Ansible の synchronize module で rsync を実行するとき
# 次のようなオプションが使われることがある
# --usermap=*:root --groupmap=*:root
# このとき * に反応してしまいコケるので、そうならないよう無理矢理回避する
# 同じ：https://github.com/ansible/ansible/issues/64971
alias rsync='noglob rsync'

alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# ghq
alias g='cd $(ghq root)/$(ghq list | peco)'

# iproute color 無効化
# https://github.com/iproute2/iproute2/blob/v6.9.0/lib/color.c#L96-L120
# NO_COLOR 効かない
alias ip='ip -color=never'
alias bridge='bridge -color=never'

# tempdir
function tempdir() {
    local date_str=$(TZ=Asia/Tokyo date +%Y%m%d)
    mkdir -p ~/temp/${date_str}-$1
    cd ~/temp/${date_str}-$1
}

# completion
zinit ice wait'!0'
zinit light zsh-users/zsh-completions

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# これより前で LS_COLORS の di を上書きしているが zsh の completion においてはそれが反映されないので
# ここで上書き
zstyle ':completion:*' list-colors 'di=01;36'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

bindkey '^[[Z' reverse-menu-complete

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

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
PURE_PROMPT_SYMBOL=$
# 見づらいので blue から変更
zstyle :prompt:pure:path color cyan

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
  # === SSH ===
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  # agent.sock は systemd service でやる
  # 2023/09 頃から、WSL2 初回起動時かつ zshrc で socat を実行すると .sock がないにも関わらず address already in use になってしまった

#   GPG 使っとらんので一旦さよなら
#   # === GPG ===
#   export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
#   if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
#     rm -rf "$GPG_AGENT_SOCK"
#     wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
#     if test -x "$wsl2_ssh_pageant_bin"; then
#       #(setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
#       (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent -gpgConfigBasepath 'C:/Users/sbdn/AppData/Local/gnupg'" >/dev/null 2>&1 &)
#     else
#       echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
#     fi
#     unset wsl2_ssh_pageant_bin
#   fi
fi

if [[ `uname -a` == *Darwin* ]]; then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
fi

autoload -U +X bashcompinit && bashcompinit

# gcloud の補完スクリプトのパスをうまく取得できないっぽい？ので超無理やりやっちゃう
gcloud_completion_file=${HOME}/.asdf/installs/gcloud/402.0.0/completion.zsh.inc
if [ -e ${gcloud_completion_file} ]; then
  . ${gcloud_completion_file}
fi

# 自前設置や
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.local/bin/scripts

export EDITOR=vi

if [[ `uname -a` == *WSL2* ]]; then
  # vault login などで cmd.exe を呼び出すため
  # /etc/wsl.conf で appendWindowsPath = false が指定されていると cmd.exe が PATH に存在しないため
  ln -s -f /mnt/c/Windows/System32/cmd.exe ${HOME}/.local/bin/cmd.exe
fi

# fly
# https://fly.io/docs/hands-on/install-flyctl/
export FLYCTL_INSTALL="${HOME}/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# last

autoload -Uz compinit && compinit

# PATH がすべて整った上で
complete -o nospace -C nomad nomad
complete -o nospace -C vault vault

# external alias
if [ -f ~/.zsh_alias_hidden ]; then
    source ~/.zsh_alias_hidden
fi
