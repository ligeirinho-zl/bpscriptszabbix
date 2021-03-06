#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

IFS=$'\n'
LG=$(aws ecs list-clusters --query "clusterArns[*]" --output json | jq -r '.[]')

for resource in $LG; do
  IFS=$'\n'
  TAGS=$(aws ecs list-tags-for-resource --resource $resource --query 'tags' | jq -r '.[] | .key')
  COUNTER=0
  for tag in $TAGS;  do
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z $1 -s "AWS" -k ecs-ids-no-tag -o $(echo $resource | cut -d ':' -f 6)
  fi
done