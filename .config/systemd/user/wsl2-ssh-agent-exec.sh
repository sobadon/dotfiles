#!/bin/bash

# systemd user service によって起動されると環境変数 WSL_INTEROP が存在しない。
# - https://github.com/microsoft/WSL/issues/8846
# - https://github.com/microsoft/WSL/issues/5065

# 環境変数 WSL_INTEROP が存在しないと npiperelay.exe の実行に失敗し、
# 結果として ssh-add -l で error fetching identities: communication with agent failed のエラーになる。

# とりあえず末尾 怪しい
export WSL_INTEROP=/run/WSL/`ls -tr /run/WSL | tail -n1`
echo aa "$WSL_INTEROP"
socat "UNIX-LISTEN:${HOME}/.ssh/agent.sock,mode=600,fork" "EXEC:/mnt/c/Users/sbdn/wsl2_tools/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent,nofork"
