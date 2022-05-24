#!/usr/bin/env bash

aws iam list-roles --query "Roles[*].RoleName"  | grep " "  | wc -l