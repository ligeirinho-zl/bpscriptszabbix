#!/usr/bin/env bash

#aws configservice describe-compliance-by-resource  --resource-type AWS::RDS::DBInstance --compliance-types NON_COMPLIANT  --query 'ComplianceByResources[*].ResourceId' --output text


aws configservice describe-compliance-by-resource  \
    --resource-type AWS::RDS::DBInstance --compliance-types NON_COMPLIANT  \
    --query 'ComplianceByResources[].ResourceId' | grep -oP '(?<=").*(?=")' | while read line || [[ -n $line ]];
do
	/usr/bin/zabbix_sender -z $1 -s "AWS" -k rds-ids-no-tags  -o $line
done