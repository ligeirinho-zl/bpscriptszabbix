#!/usr/bin/env bash

IFS=$'\t'
LG=$(aws configservice get-compliance-details-by-config-rule --config-rule-name snapshot-rds-no-tags --compliance-types NON_COMPLIANT --query 'EvaluationResults[*].EvaluationResultIdentifier.EvaluationResultQualifier.ResourceId' --output text)

for resource in $LG; do
  /usr/bin/zabbix_sender -z $1 -s "AWS" -k snapshot-db-ids-no-tag -o $resource
done