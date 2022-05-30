#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r JSONTMP=/tmp/zbx-ec2-ami-ids-hdf454sdfds45.json

aws ec2 describe-images --owners self --query 'Images[*]' --output json > $JSONTMP

jsonArrayLength=$(jq '. | length' $JSONTMP)

for (( i=0; i<$jsonArrayLength ; i++ )); do
  idAMI=$(jq ".[$i] | .ImageId" $JSONTMP | grep -oP '(?<=").*(?=")')
  tagsAMICount=$(jq ".[$i] | .Tags | length" $JSONTMP)
  for (( j=0; j < $tagsAMICount ; j++ )); do
    tag=$(jq ".[$i] | .Tags | .[$j] | .Key" $JSONTMP | grep -oP '(?<=").*(?=")')
    if [[ -v tagsVerify[$tag] ]]; then
      let "COUNTER++"
    fi
  done
  if [[ $COUNTER -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z $1 -s "AWS" -k ec2-ami-ids -o $idAMI
  fi
done

rm -f $JSONTMP