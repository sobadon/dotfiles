#!/bin/bash

# nomad-alloc-status-by-job.sh <job_id>

set -eu

job_id=$1
alloc_ids=$(nomad job allocs -t '{{ range . }}{{ if eq .ClientStatus "running" }}{{ println .ID }}{{ end }}{{ end }}' $job_id)

for alloc_id in $alloc_ids; do
  echo ""
  echo "===================="
  nomad alloc status $alloc_id
done
