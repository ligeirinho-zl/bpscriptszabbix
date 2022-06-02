#!/usr/bin/env bash

CSVFILE=/tmp/relatorio-no-tags-bp.csv
RELDOME=/tmp/dome9-report.csv
DIR="$(dirname "$(realpath "$0")")"

# Generate report Tags
$DIR/aws-report-tags.sh

# Generate report Dome9
python3 "$DIR/dome9_assessment.py" -o csv -f $RELDOME

cat $RELDOME >> $CSVFILE