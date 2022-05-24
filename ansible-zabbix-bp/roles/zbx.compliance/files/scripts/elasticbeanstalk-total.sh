#!/usr/bin/env bash

aws elasticbeanstalk describe-applications --query "Applications[].ApplicationName" | grep " "  | wc -l