#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r JSONTMP=/tmp/ec2-ami-ids-898sd8as712.json

set -e

aws ec2 describe-images --owners self --query 'Images[*].[ImageId,Tags[].Key]' --output json > $JSONTMP

jsonArrayLength=$(jq '. | length' $JSONTMP)

for i in $jsonArrayLength; do
  idAMI=$(jq ".[(($i-1))] | .[0]" $JSONTMP | grep -oP '(?<=").*(?=")')
  tagsAMICount=$(jq ".[(($i-1))] | .[1] | length" $JSONTMP)
  for j in $tagsAMICount; do
    tag=$(jq ".[(($i-1))] | .[1] | .[(($j-1))]" $JSONTMP | grep -oP '(?<=").*(?=")')
    if [[ -v tagsVerify[$tag] ]]; then
      let "COUNTER++"
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k ec2-ami-ids -o $idAMI
  fi
done

rm -f $TEMPFILE