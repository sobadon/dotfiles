#!/bin/bash

# nomad-alloc-status-by-job.sh <job_id>

set -eux

# ジョブ名を引数から取得
job_id=$1
# running が 2 つ以上あると壊れる
alloc_id=$(nomad job allocs -t '{{ range . }}{{ if eq .ClientStatus "running" }}{{ println .ID }}{{ end }}{{ end }}' $job_id)

nomad alloc status $alloc_id
