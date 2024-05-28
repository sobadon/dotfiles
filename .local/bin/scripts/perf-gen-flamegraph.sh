#!/bin/bash

# カレントディレクトリにある *.data ファイルの最新を flamegraph に変換
# sudo perf record -a -g -o perf-$(date +%Y%m%d-%H%M%S).data
# -> perf-20240528-161937.data

# Usage:
# perf-gen-flamegraph.sh

set -e pipefail

# 最新の *.data ファイルを取得
latest_data_file=$(ls -t *.data | head -n 1)
timestamp=$(echo $latest_data_file | grep -oP '\d{8}-\d{6}')
output_file="perf-flamegraph-$timestamp.svg"
perf script -i "$latest_data_file" | stackcollapse-perf.pl | flamegraph.pl > "$output_file"

echo "Generated flame graph: $output_file"
