#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

IFS=$'\n'
LG=$(aws lambda list-functions --query 'Functions[*].FunctionArn' --output json | jq -r '.[]')

for resource in $LG; do
  IFS=$'\n'
  TAGS=$(aws lambda list-tags --resource $resource --query 'Tags' | jq -r 'keys[]')
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