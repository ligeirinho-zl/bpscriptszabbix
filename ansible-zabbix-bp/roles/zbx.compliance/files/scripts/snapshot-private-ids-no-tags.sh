#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r JSONTMP=/tmp/zbx-ec2-snapshots-no-tags-1fd2s1fsd2f1sd.json

aws ec2 describe-snapshots --owner-ids self --query 'Snapshots[*]' --output json > $JSONTMP

jsonArrayLength=$(jq '. | length' $JSONTMP)

for (( i=0; i<$jsonArrayLength ; i++ )); do
  snapshotId=$(jq ".[$i].SnapshotId" $JSONTMP | grep -oP '(?<=").*(?=")')
  tagsSnapshotCount=$(jq ".[$i] | .Tags | length" $JSONTMP)
  COUNTER=0
  for (( j=0; j < $tagsSnapshotCount ; j++ )); do
    tag=$(jq ".[$i] | .Tags | .[$j] | .Key" $JSONTMP | grep -oP '(?<=").*(?=")')
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z $1 -s "AWS" -k snapshot-ids-no-tag -o $snapshotId
  fi
done

rm -f $JSONTMP