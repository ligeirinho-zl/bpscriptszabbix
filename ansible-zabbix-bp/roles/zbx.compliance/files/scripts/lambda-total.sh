#!/usr/bin/env bash

aws lambda list-functions --query "Functions[*].FunctionName" | grep " " | wc -l