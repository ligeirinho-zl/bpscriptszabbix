#!/usr/bin/env bash

aws configservice describe-compliance-by-resource  \
    --resource-type AWS::ElasticBeanstalk::Application --compliance-types NON_COMPLIANT  \
    --query 'ComplianceByResources[].ResourceId' | grep -oP '(?<=").*(?=")' | while read line || [[ -n $line ]];
do
	/usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k elasticbeanstalk-ids-no-tag  -o $(echo $line | cut -d ':' -f 6)
done