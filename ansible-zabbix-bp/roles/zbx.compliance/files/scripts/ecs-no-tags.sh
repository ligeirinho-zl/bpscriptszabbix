#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-ecs-no-tags-345asd45asd31.tmp
declare -r TEMPFILECOMPLIANCE=/tmp/zbx-ecs-no-tags-sda4d5sad4a.tmp

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
    let totalNonCompliance++
    echo $totalNonCompliance > $TEMPFILECOMPLIANCE
  fi
done

echo $(cat $TEMPFILECOMPLIANCE)

unlink $TEMPFILE
rm -f $TEMPFILE
rm -f $TEMPFILECOMPLIANCE