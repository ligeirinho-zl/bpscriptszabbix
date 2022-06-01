#!/usr/bin/env bash

RELFILE=/tmp/relatorio-no-tags-bp.csv

DIR="$(dirname "$(realpath "$0")")"
"$DIR"/aws-report-tags.sh > /dev/null

if [ -f "$RELFILE" ]; then
  wc -l < $RELFILE
fi