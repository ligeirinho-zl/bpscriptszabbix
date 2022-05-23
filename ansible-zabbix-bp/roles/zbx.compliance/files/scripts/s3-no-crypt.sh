#!/usr/bin/env bash

aws configservice get-compliance-details-by-config-rule --config-rule-name bp-s3-encryption --compliance-types NON_COMPLIANT  --query 'EvaluationResults[*].EvaluationResultIdentifier.EvaluationResultQualifier.ResourceId' --output json | grep -oP '(?<=").*(?=")' | while read line || [[ -n $line ]];
do
   /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k S3-unencrypted-ids -o $line
done