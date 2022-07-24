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

# last

autoload -Uz compinit && compinit
