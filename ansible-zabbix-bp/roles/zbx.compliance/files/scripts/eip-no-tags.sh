#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r JSONTMP=/tmp/zbx-ec2-eip-no-tags-das56da565.json

aws ec2 describe-addresses --query 'Addresses[*]' --output json > $JSONTMP

jsonArrayLength=$(jq '. | length' $JSONTMP)

for (( i=0; i<$jsonArrayLength ; i++ )); do
  tagsEIPCount=$(jq ".[$i] | .Tags | length" $JSONTMP)
  COUNTER=0
  for (( j=0; j < $tagsEIPCount ; j++ )); do
    tag=$(jq ".[$i] | .Tags | .[$j] | .Key" $JSONTMP | grep -oP '(?<=").*(?=")')
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    let TOTALNOIDS++
  fi
done

echo $TOTALNOIDS

rm -f $JSONTMP