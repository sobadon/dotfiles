#!/usr/bin/env bash

set -eu

REPO_DIR="${HOME}/ghq/git.chasoba.net/sobadon/ssh-config"

if [[ ! -d "${REPO_DIR}" ]]; then
  echo "not found repo directory: ${REPO_DIR}"
  exit 1
fi

cd "${REPO_DIR}"

if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "Update from $(hostname)"
fi

git pull --autostash origin $(git branch --show-current)
git push origin $(git branch --show-current)

cd - > /dev/null
