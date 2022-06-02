#!/usr/bin/env bash

IFS=$'\n'
LG=$(aws configservice describe-compliance-by-resource --resource-type AWS::EC2::Instance --compliance-types NON_COMPLIANT --query 'ComplianceByResources[].ResourceId' --output json | jq -r '.[]')

for resource in $LG; do
	/usr/bin/zabbix_sender -z $1 -s "AWS" -k ec2-ids-no-tags -o $resource
done