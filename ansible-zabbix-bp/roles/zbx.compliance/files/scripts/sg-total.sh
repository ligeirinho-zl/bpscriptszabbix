#!/usr/bin/env bash

aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId' --output json | grep " " | wc -l