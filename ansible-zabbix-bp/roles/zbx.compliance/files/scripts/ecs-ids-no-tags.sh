#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-ecs-ids-no-tags-d87ad45a4da78.tmp

aws ecs list-clusters --query "clusterArns[*]" --output json | grep -oP '(?<=").*(?=")' | while read ecsARN || [[ -n $ecsARN ]];
do
  echo 0 > $TEMPFILE
  aws ecs list-tags-for-resource --resource $ecsARN --query 'tags' | jq -c '.[] | .key' | grep -oP '(?<=").*(?=")' | while read tags || [[ -n $tags ]];
  do
    if [[ -v tagsVerify[$tags] ]]; then
      COUNTER=$[$(cat $TEMPFILE) + 1]
      echo $COUNTER > $TEMPFILE
    fi
  done
  if [[ $(cat $TEMPFILE) -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k ecs-ids-no-tag -o $(echo $ecsARN | cut -d ':' -f 6)
  fi
done

if [ -f "$TEMPFILE" ]
then
  unlink $TEMPFILE
  rm -f $TEMPFILE
fi