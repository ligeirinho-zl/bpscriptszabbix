#!/usr/bin/env bash

aws ec2 describe-snapshots --query "Snapshots[*].SnapshotId" | grep " " | wc -l