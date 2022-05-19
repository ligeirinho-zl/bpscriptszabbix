#! /usr/bin/bash


aws configservice describe-compliance-by-config-rule --config-rule-name LB-no-Tags --compliance-types NON_COMPLIANT --query "ComplianceByConfigRules[*].Compliance.ComplianceContributorCount.CappedCount" --output text

