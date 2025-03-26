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

# OSC 133
# https://gitlab.freedesktop.org/Per_Bothner/specifications/-/blob/master/proposals/prompts-data/shell-integration.zsh
_prompt_executing=""
function __prompt_precmd() {
    local ret="$?"
    if test "$_prompt_executing" != "0"
    then
      _PROMPT_SAVE_PS1="$PS1"
      _PROMPT_SAVE_PS2="$PS2"
      PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
      PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi
    if test "$_prompt_executing" != ""
    then
      printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    _prompt_executing=0
}
function __prompt_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    _prompt_executing=1
}
preexec_functions+=(__prompt_preexec)
precmd_functions+=(__prompt_precmd)

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

# history search peco
# https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

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

# 日本語ファイル名
# setopt print_eight_bit

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

# 矢印前後
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zinit load 'zsh-users/zsh-history-substring-search'
zinit ice wait atload'_history_substring_search_config'
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# theme
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
PURE_PROMPT_SYMBOL=$

# plugin
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light hlissner/zsh-autopair
zinit light olets/zsh-abbr

autoload -U +X bashcompinit && bashcompinit

# 自前設置や
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.local/bin/scripts

# last

autoload -Uz compinit && compinit
