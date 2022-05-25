#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-app-distributions-no-tags-dasd54ad65s4da6.tmp

aws cloudfront list-distributions --query "DistributionList.Items[].ARN" --output json | grep -oP '(?<=").*(?=")' | while read distARN || [[ -n $distARN ]];
do
  echo 0 > $TEMPFILE
  aws cloudfront list-tags-for-resource --resource $distARN --query 'Tags.Items[].Key' | grep -oP '(?<=").*(?=")' | while read tags || [[ -n $tags ]];
  do
    if [[ -v tagsVerify[$tags] ]]; then
      COUNTER=$[$(cat $TEMPFILE) + 1]
      echo $COUNTER > $TEMPFILE
    fi
  done
  if [[ $(cat $TEMPFILE) -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z 54.207.205.224 -s "AWS" -k cloudfront-ids-no-tag -o $(echo $distARN | cut -d ':' -f 6)
  fi
done

if [ -f "$TEMPFILE" ]
then
  unlink $TEMPFILE
  rm -f $TEMPFILE
fi