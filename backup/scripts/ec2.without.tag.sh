#!/bin/bash

#aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId, Tags]" --output text | grep bp: | wc -l

aws configservice describe-compliance-by-config-rule --config-rule-name ec2-sem-tags  --query 	'ComplianceByConfigRules[*].Compliance.ComplianceContributorCount.CappedCount'  --output text

##aws ec2 describe-instances --filters Name=instance-state-name,Values="*" --query "Reservations[*].Instances[].[InstanceId]" --output text  | wc -l

