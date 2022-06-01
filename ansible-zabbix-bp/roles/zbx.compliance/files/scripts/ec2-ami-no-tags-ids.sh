#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}

JSONTMP=$(aws ec2 describe-images --owners self --query 'Images[*]' --output json)

jsonArrayLength=$(echo $JSONTMP | jq -r '. | length')

for (( i=0; i<$jsonArrayLength ; i++ )); do
  idAMI=$(echo $JSONTMP | jq -r ".[$i] | .ImageId")
  tagsAMICount=$(echo $JSONTMP | jq -r ".[$i] | .Tags | length")
  COUNTER=0
  for (( j=0; j < $tagsAMICount ; j++ )); do
    tag=$(echo $JSONTMP | jq -r ".[$i] | .Tags | .[$j] | .Key")
    if [[ -v tagsVerify[$tag] ]]; then
      let COUNTER++
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z $1 -s "AWS" -k ec2-ami-ids -o $idAMI
  fi
done