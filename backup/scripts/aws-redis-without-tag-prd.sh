#!/bin/bash

###############################################################################
#################################  Maxmilhas  #################################
# Script created by Cloud and Monitoring Team - 2020
# Usage example:
###############################################################################
###############################################################################

declare -i count='0'
#declare -i count_total='0'
lista=$(aws elasticache describe-cache-clusters --query 'CacheClusters[*].CacheClusterId' | grep -v "\[" | grep -v "\]" | sed -e 's/\"//g' | sed -e 's/\,//g' | wc -l)
for OUTPUT in $(aws elasticache describe-cache-clusters --query 'CacheClusters[*].CacheClusterId' | grep -v "\[" | grep -v "\]" | sed -e 's/\"//g' | sed -e 's/\,//g')
do
    
list_tag=""
list_tag=$(aws elasticache list-tags-for-resource --resource-name arn:aws:elasticache:sa-east-1:960186560019:cluster:$OUTPUT 2> /dev/null)


if [[ $list_tag =~ "bp" ]];
    then

#echo -e '\033[01;32mTem Tag bp - Nome do Nó: '$OUTPUT'\033[00;37m' 
count=$count+1 
    #else
#echo -e '\033[01;31mNão Tem Tag bp - Nome do Nó: '$OUTPUT'\033[00;37m'    


fi
#echo "========================================================================================"

done    

total=$(($lista - $count))
echo $total

