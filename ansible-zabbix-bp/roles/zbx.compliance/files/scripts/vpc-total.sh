#!/usr/bin/env bash

aws ec2 describe-vpcs --query 'Vpcs[].VpcId' | grep " " | wc -l