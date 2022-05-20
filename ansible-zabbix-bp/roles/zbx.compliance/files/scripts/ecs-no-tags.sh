#!/usr/bin/env bash

aws configservice describe-compliance-by-config-rule --config-rule-name ecs-no-tags --query 'ComplianceByConfigRules[*].Compliance.ComplianceContributorCount.CappedCount' --output text