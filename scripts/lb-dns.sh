#! /usr/bin/bash


aws elbv2 describe-load-balancers --query "LoadBalancers[*].DNSName" --output text
aws elb describe-load-balancers --query "LoadBalancerDescriptions[*].DNSName" --output text

