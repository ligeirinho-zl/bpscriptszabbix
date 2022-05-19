#!/usr/bin/env bash


aws configservice describe-compliance-by-resource  --resource-type AWS::EC2::Instance --compliance-types NON_COMPLIANT  --query 'ComplianceByResources[*].ResourceId' --output json
#aws configservice describe-compliance-by-resource  --resource-type AWS::EC2::Instance --compliance-types NON_COMPLIANT  --query 'ComplianceByResources[].ResourceId' | grep -oP '(?<=").*(?=")'

#aws configservice describe-compliance-by-resource  \
#    --resource-type AWS::EC2::Instance --compliance-types NON_COMPLIANT  \
#    --query 'ComplianceByResources[].ResourceId' | grep -oP '(?<=").*(?=")' | while read line || [[ -n $line ]];
#do
#   /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k ec2-ids-no-tags -o $line
#done
