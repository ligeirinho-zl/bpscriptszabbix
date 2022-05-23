#!/bin/bash

aws configservice describe-compliance-by-config-rule --config-rule-name s3-sem-tag --query 	'ComplianceByConfigRules[*].Compliance.ComplianceContributorCount.CappedCount'  --output text


