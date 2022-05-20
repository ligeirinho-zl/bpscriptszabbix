#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r JSONTMP=/tmp/zbx-ec2-eip-ids-9893128391283.json

set -e

aws ec2 describe-addresses --query 'Addresses[*]' --output json > $JSONTMP

jsonArrayLength=$(jq '. | length' $JSONTMP)

for (( i=0; i<$jsonArrayLength ; i++ )); do
  idIP=$(jq ".[$i] | .PublicIp" $JSONTMP | grep -oP '(?<=").*(?=")')
  tagsEIPCount=$(jq ".[(($i-1))] | .Tags | length" $JSONTMP)
  COUNTER=0
  for (( j=0; j < $tagsEIPCount ; j++ )); do
    tag=$(jq ".[$i] | .Tags | .[$j] | .Key" $JSONTMP | grep -oP '(?<=").*(?=")')
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k eip-ids-no-tag -o $idIP
  fi
done

rm -f $TEMPFILE