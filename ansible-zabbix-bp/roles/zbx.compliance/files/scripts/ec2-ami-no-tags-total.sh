#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r JSONTMP=/tmp/zbx-ec2-ami-ids-898sd8as712.json

aws ec2 describe-images --owners self --query 'Images[*].[ImageId,Tags[].Key]' --output json > $JSONTMP

jsonArrayLength=$(jq '. | length' $JSONTMP)

for (( i=0; i<$jsonArrayLength ; i++ )); do
  idAMI=$(jq ".[$i] | .[0]" $JSONTMP | grep -oP '(?<=").*(?=")')
  tagsAMICount=$(jq ".[$i] | .[1] | length" $JSONTMP)
  for (( j=0; j < $tagsAMICount ; j++ )); do
    tag=$(jq ".[$i] | .[1] | .[$j]" $JSONTMP | grep -oP '(?<=").*(?=")')
    if [[ -v tagsVerify[$tag] ]]; then
      let "COUNTER++"
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    let TOTALNOIDS++
  fi
done

echo $TOTALNOIDS

rm -f $JSONTMP