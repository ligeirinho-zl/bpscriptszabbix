#!/usr/bin/env bash

IFS=$'\n'
LG=$(aws configservice get-compliance-details-by-config-rule --config-rule-name LB-no-Tags --compliance-types NON_COMPLIANT --query 'EvaluationResults[*].EvaluationResultIdentifier.EvaluationResultQualifier.ResourceId' --output json | jq -r '.[]')

for resource in $LG; do
  /usr/bin/zabbix_sender -z $1 -s "AWS" -k elb-no-tags-names -o $(echo $resource | cut -d ':' -f 6)
done