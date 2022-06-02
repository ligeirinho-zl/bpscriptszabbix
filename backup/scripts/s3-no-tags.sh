#!/bin/bash

aws configservice get-compliance-details-by-config-rule --config-rule-name s3-sem-tag --compliance-types NON_COMPLIANT \
	--query 'EvaluationResults[*].EvaluationResultIdentifier.EvaluationResultQualifier.ResourceId' \
	--output json | grep -oP '(?<=").*(?=")' | while read line || [[ -n $line ]];
do
   /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k s3.prd.names -o $line
done
