# dotfiles

## Windows + WSL2

- Linux 側 OpenSSH より Windows 側 OpenSSH のバージョンが勝つようにする。
  ```
  # https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH
  # beta の latest
  winget install "openssh beta"
  ```
- gpg-connect-agent との競合するのを防ぐため Windows 側 OpenSSH Agent サービスを停止しなければならない。あわせて自動起動を無効にする。
  - gpg-connect-agent が `SSH_AUTH_SOCK=\\.\pipe\openssh-ssh-agent` を作る
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

`%appdata%\gnupg\gpg-agent.conf`

```
enable-putty-support
enable-ssh-support
enable-win32-openssh-support
```

```sh
systemctl --user daemon-reload
systemctl --user enable --now wsl2-ssh-agent.service
```

## memo

- Windows Terminal で WSL2 を利用している環境にて、2023/12 の Windows Update 頃から、ターミナルウィンドウを開いて、さらに追加でターミナルウィンドウを開いて計 2 コ存在する状態で、古いターミナルウィンドウを消して残ったターミナルウィンドウで `ssh-add -l` すると以下エラーになる
  - `error fetching identities: communication with agent failed`
  - `systemctl --user restart wsl2-ssh-agent.service` でなおる
  - `/run/WSL/**_interop` の挙動が変わった
