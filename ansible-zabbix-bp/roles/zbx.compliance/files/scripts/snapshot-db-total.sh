#!/usr/bin/env bash

aws rds describe-db-snapshots --no-include-public --query "DBSnapshots[*].DBSnapshotIdentifier" | grep " " | wc -l