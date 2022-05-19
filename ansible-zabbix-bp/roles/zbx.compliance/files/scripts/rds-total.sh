#!/usr/bin/env bash

aws rds describe-db-instances --query DBInstances[*].DBInstanceIdentifier --output text | wc -l
