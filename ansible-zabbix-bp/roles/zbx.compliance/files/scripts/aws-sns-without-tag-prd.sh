#!/usr/bin/env bash

###############################################################################
#################################  Maxmilhas  #################################
# Script created by Cloud and Monitoring Team - 2020
# Usage example:
###############################################################################
###############################################################################

declare -i count='0'
lista=$(aws sns list-topics | grep -v "\[" | grep -v "\]" | grep -v "\{" | grep -v "\}" | sed -e 's/\"//g' | sed -e 's/\TopicArn://g' | wc -l)
for OUTPUT in $(aws sns list-topics | grep -v "\[" | grep -v "\]" | grep -v "\{" | grep -v "\}" | sed -e 's/\"//g' | sed -e 's/\TopicArn://g')
do

list_tag=""
list_tag=$(aws sns list-tags-for-resource --resource-arn $OUTPUT  2> /dev/null )
if [[ $list_tag =~ "bp" ]]
then
    #echo -e '\033[05;32mTem Tag bp: '$OUTPUT'\033[00;37m'

#else
    #echo -e '\033[05;31mNão Tem Tag bp: '$OUTPUT'\033[00;37m'
count=$count+1

fi
#echo "==============================================================================="
done
total=$(($lista - $count))
echo $total
