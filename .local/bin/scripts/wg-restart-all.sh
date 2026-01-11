#!/usr/bin/env bash

set -ux

if [[ $(hostname) == "nade2" ]]; then
    wg_ifs=("wg1")
    for wg_if in ${wg_ifs[@]}; do
        sudo wg-quick down "${wg_if}" ; sudo wg-quick up "${wg_if}"
    done
fi
