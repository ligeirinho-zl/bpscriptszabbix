#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

IFS=$'\n'
LG=$(aws elasticbeanstalk describe-applications --query "Applications[].ApplicationArn" --output json | jq -r '.[]')

for resource in $LG; do
  IFS=$'\n'
  TAGS=$(aws elasticbeanstalk list-tags-for-resource --resource $resource --query 'ResourceTags' | jq -r '.[] | .key')
  COUNTER=0
  for tag in $TAGS;  do
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    let totalNonCompliance++
  fi
done

echo $totalNonCompliance