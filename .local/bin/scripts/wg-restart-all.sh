#!/usr/bin/env bash

set -ux

if [[ $(hostname) == "nade2" ]]; then
    wg_ifs=("wg0" "wg1" "wg2" "wg3")
    for wg_if in ${wg_ifs[@]}; do
        sudo wg-quick down "${wg_if}" ; sudo wg-quick up "${wg_if}"
    done
fi
