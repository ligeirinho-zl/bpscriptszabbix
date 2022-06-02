#!/usr/bin/env bash

IFS=$'\n'
LG=$(aws configservice get-compliance-details-by-config-rule --config-rule-name bp-s3-encryption --compliance-types NON_COMPLIANT  --query 'EvaluationResults[*].EvaluationResultIdentifier.EvaluationResultQualifier.ResourceId' --output json | jq -r '.[]')

for resource in $LG; do
  /usr/bin/zabbix_sender -z $1 -s "AWS" -k S3-unencrypted-ids -o $resource
done