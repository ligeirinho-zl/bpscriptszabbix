#!/usr/bin/env bash

aws ecs list-clusters --query "clusterArns[*]" --output text  | wc -l