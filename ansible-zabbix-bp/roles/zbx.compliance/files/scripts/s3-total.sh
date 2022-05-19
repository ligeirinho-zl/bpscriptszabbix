#!/usr/bin/env bash

aws s3api list-buckets --query "Buckets[*].Name"  | grep " " | wc -l