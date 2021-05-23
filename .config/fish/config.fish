set -x GOPATH $HOME/go
set -x PATH $PATH /usr/lib/go-1.15/bin $GOPATH/bin
set -gx PATH $PATH $HOME/.krew/bin
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_DEFAULT_OPTS "--reverse --height=100%"

# https://qiita.com/itkrt2y/items/0671d1f48e66f21241e2
alias g='cd (ghq root)/(ghq list | peco)'

alias vim='nvim'

abbr -a ll 'ls -alh'

abbr -a k 'kubectl'

abbr -a initvim 'vim ~/.config/nvim/init.vim'
abbr -a dein 'vim ~/.config/nvim/dein.toml'
abbr -a deinlazy 'vim ~/.config/nvim/dein_lazy.toml'

abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gap 'git add -p'
abbr -a gc 'git commit'
abbr -a gd 'git diff'
abbr -a gds 'git diff --staged'

abbr -a fishreload 'source ~/.config/fish/config.fish'
abbr -a configfish 'vim ~/.config/fish/config.fish'

abbr -a sshbackup '/home/sbdn/ghq/github.com/sobadon/backup-script/wsl/backup-ssh-config.sh backup'
abbr -a sshrestore '/home/sbdn/ghq/github.com/sobadon/backup-script/wsl/backup-ssh-config.sh restore'

function curlb -d "curl TTFB"
  curl -ko /dev/null \
  -H 'Cache-Control: no-cache' \
  -s \
  -w 'Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n' \
  "$argv"
end

