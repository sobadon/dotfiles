#!/usr/bin/env bash

set -eu

REPO_DIR="${HOME}/ghq/git.chasoba.net/sobadon/wiki"

if [[ ! -d "${REPO_DIR}" ]]; then
  echo "not found repo directory: ${REPO_DIR}"
  exit 1
fi

cd "${REPO_DIR}"

git pull --rebase --autostash origin $(git branch --show-current)

if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "update"
  git push origin $(git branch --show-current)
fi

cd - > /dev/null
