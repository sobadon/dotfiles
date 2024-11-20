# dotfiles

## Windows11 24H2 + WSL2

- gpg-connect-agent との競合するのを防ぐため Windows 側 OpenSSH Agent サービスを停止しなければならない。あわせて自動起動を無効にする。
  - gpg-connect-agent が `SSH_AUTH_SOCK=\\.\pipe\openssh-ssh-agent` を作る
  ```
  sc config ssh-agent start=disabled
  sc stop ssh-agent
  ```
- gpg4win 4.1.0, 4.2.0, 4.3.1 で動いた。
  - `gpg-connect-agent /bye` は必要
- `enable-win32-openssh-support` によって `//./pipe/openssh-ssh-agent` にパイプができあがる？
- `%appdata%\gnupg\gpg-agent.conf`

  ```
  enable-putty-support
  enable-ssh-support
  enable-win32-openssh-support
  ```
- npiperelay
  - https://github.com/jstarks/npiperelay/releases
  - `/mnt/c/Users/sbdn/wsl2_tools/npiperelay.exe` へ
- `%appdata%\gnupg\gpg-agent.conf`

    ```
    enable-putty-support
    enable-ssh-support
    enable-win32-openssh-support
    ```
- いろいろ自動起動

    ```sh
    systemctl --user daemon-reload
    systemctl --user enable --now wsl2-ssh-agent.service
    systemctl --user enable --now wsl2-workaround-startup.service
    ```

## neovim dependency

```shell
sudo apt install ripgrep cmake clang build-essential wl-clipboard -y
```

## memo

- Windows Terminal で WSL2 を利用している環境にて、2023/12 の Windows Update 頃から、ターミナルウィンドウを開いて、さらに追加でターミナルウィンドウを開いて計 2 コ存在する状態で、古いターミナルウィンドウを消して残ったターミナルウィンドウで `ssh-add -l` すると以下エラーになる
  - `error fetching identities: communication with agent failed`
  - `systemctl --user restart wsl2-ssh-agent.service` でなおる
  - `/run/WSL/**_interop` の挙動が変わった
- Windows & WSL2 & YubiKey：https://memo.chasoba.net/p/59755/
