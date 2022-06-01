#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

JSONTMP=$(aws ec2 describe-addresses --query 'Addresses[*]' --output json)

jsonArrayLength=$(echo $JSONTMP | jq -r '. | length')

for (( i=0; i<$jsonArrayLength ; i++ )); do
  idIP=$(echo $JSONTMP | jq -r ".[$i] | .PublicIp")
  tagsEIPCount=$(echo $JSONTMP | jq -r ".[$i] | .Tags | length")
  COUNTER=0
  for (( j=0; j < $tagsEIPCount ; j++ )); do
    tag=$(echo $JSONTMP | jq -r ".[$i] | .Tags | .[$j] | .Key")
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z $1 -s "AWS" -k eip-ids-no-tag -o $idIP
  fi
done