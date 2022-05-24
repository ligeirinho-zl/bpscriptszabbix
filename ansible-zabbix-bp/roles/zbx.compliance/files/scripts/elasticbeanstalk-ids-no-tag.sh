#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-app-ids-no-tags-fa12da21sd.tmp

aws elasticbeanstalk describe-applications --query "Applications[].ApplicationArn" --output json | grep -oP '(?<=").*(?=")' | while read appARN || [[ -n $appARN ]];
do
  echo 0 > $TEMPFILE
  aws elasticbeanstalk list-tags-for-resource --resource $appARN --query 'ResourceTags' | jq -c '.[] | .key' | grep -oP '(?<=").*(?=")' | while read tags || [[ -n $tags ]];
  do
    if [[ -v tagsVerify[$tags] ]]; then
      COUNTER=$[$(cat $TEMPFILE) + 1]
      echo $COUNTER > $TEMPFILE
    fi
  done
  if [[ $(cat $TEMPFILE) -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k elasticbeanstalk-ids-no-tag -o $(echo $appARN | cut -d ':' -f 6)
  fi
done

unlink $TEMPFILE
rm -f $TEMPFILE