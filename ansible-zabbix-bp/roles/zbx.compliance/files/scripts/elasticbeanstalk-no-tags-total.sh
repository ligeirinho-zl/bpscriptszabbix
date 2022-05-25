#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-app-no-tags-dsa1c2cwdas.tmp
declare -r TEMPFILECOMPLIANCE=/tmp/zbx-compliance-app-no-tags-dsa1c2cwdas.tmp

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
    let totalNonCompliance++
    echo $totalNonCompliance > $TEMPFILECOMPLIANCE
  fi
done

echo $(cat $TEMPFILECOMPLIANCE 2>/dev/null || echo 0)

if [ -f "$TEMPFILE" ]
then
  unlink $TEMPFILE
  rm -f $TEMPFILE
fi

if [ -f "$TEMPFILECOMPLIANCE" ]
then
  rm -f $TEMPFILECOMPLIANCE
fi