#! /usr/bin/bash

aws lambda list-functions --query "Functions[*].FunctionName" | grep " " | wc -l

