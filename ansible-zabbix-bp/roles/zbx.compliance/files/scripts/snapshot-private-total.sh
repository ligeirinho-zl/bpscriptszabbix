#!/usr/bin/env bash

aws ec2 describe-snapshots --owner-ids self --query "Snapshots[*].SnapshotId" | grep " " | wc -l