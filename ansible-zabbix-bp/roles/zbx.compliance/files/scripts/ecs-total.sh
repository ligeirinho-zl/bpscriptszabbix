#!/usr/bin/env bash

aws ecs list-clusters --query "clusterArns[*]" --output json | grep " " | wc -l