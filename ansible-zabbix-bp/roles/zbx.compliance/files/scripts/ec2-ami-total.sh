#!/usr/bin/env bash

aws ec2 describe-images --owners self --query "Images[*].ImageId" --output json | grep -oP '(?<=").*(?=")' | wc -l