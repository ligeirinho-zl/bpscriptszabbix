#!/usr/bin/env bash

aws ec2 describe-addresses --query 'Addresses[].PublicIp' | grep " " | wc -l