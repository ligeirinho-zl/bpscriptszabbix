#!/usr/bin/env bash

aws cloudfront list-distributions --query "DistributionList.Items[].Id"  | grep " "  | wc -l