# dotfiles

## Windows + WSL2

- Linux 側 OpenSSH より Windows 側 OpenSSH のバージョンが勝つようにする。
  ```
  # https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH
  # beta の latest
  winget install "openssh beta"
  ```
- Windows 側 OpenSSH Agent サービスは不要だから停止して自動起動は無効。
  ```
  sc config ssh-agent start=disabled
  sc stop ssh-agent
  ```
- gpg4win 4.1.0, 4.2.0 で動いた。
  - `gpg-connect-agent /bye` は必要
- `enable-win32-openssh-support` によって `//./pipe/openssh-ssh-agent` にパイプができあがる？
- Windows ユーザー側環境変数 `SSH_AUTH_SOCK` に `\\.\pipe\openssh-ssh-agent` を設定する
- https://github.com/benpye/wsl-ssh-pageant は不要だった

- `%appdata%\gnupg\gpg-agent.conf`
  ```
  enable-putty-support
  enable-ssh-support
  enable-win32-openssh-support
  ```

- npiperelay
  - https://github.com/jstarks/npiperelay/releases
