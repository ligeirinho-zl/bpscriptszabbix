#!/usr/bin/env bash

aws configservice describe-compliance-by-config-rule --config-rule-name sg-no-tags --query 'ComplianceByConfigRules[*].Compliance.ComplianceContributorCount.CappedCount' --output text