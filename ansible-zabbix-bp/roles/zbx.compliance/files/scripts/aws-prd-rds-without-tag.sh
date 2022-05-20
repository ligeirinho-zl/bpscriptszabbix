#!/usr/bin/env bash

aws configservice describe-compliance-by-config-rule --config-rule-name RDS-sem-tags  --query  'ComplianceByConfigRules[*].Compliance.ComplianceContributorCount.CappedCount' --output text