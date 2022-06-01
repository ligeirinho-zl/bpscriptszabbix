#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

IFS=$'\t'
LG=$(aws cloudfront list-distributions --query "DistributionList.Items[].ARN" --output text)

for resource in $LG; do
  IFS=$'\n'
  TAGS=$(aws cloudfront list-tags-for-resource --resource $resource --query 'Tags.Items[].Key' | jq -r '.[]')
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