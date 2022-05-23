#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-lambda-no-tags-123189317482171.tmp
declare -r TEMPFILECOMPLIANCE=/tmp/zbx-lambda-no-tags-d56as4dasd5a4mac.tmp

aws lambda list-functions --query 'Functions[*].FunctionArn' --output json | grep -oP '(?<=").*(?=")' | while read functionARN || [[ -n $functionARN ]];
do
  echo 0 > $TEMPFILE
  aws lambda list-tags --resource $functionARN --query 'Tags' | jq -r 'keys[]' | while read tags || [[ -n $tags ]];
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