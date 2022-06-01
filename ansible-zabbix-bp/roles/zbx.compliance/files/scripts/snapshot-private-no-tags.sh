#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

JSONTMP=$(aws ec2 describe-snapshots --owner-ids self --query 'Snapshots[*]' --output json)

jsonArrayLength=$(echo $JSONTMP | jq -r '. | length')

for (( i=0; i<$jsonArrayLength ; i++ )); do
  tagsSnapshotCount=$(echo $JSONTMP | jq -r ".[$i] | .Tags | length")
  COUNTER=0
  for (( j=0; j < $tagsSnapshotCount ; j++ )); do
    tag=$(echo $JSONTMP | jq -r ".[$i] | .Tags | .[$j] | .Key")
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    let TOTALNOIDS++
  fi
done

echo $TOTALNOIDS