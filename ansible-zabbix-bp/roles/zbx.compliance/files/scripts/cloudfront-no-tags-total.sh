#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-distributions-no-tags-56das5da.tmp
declare -r TEMPFILECOMPLIANCE=/tmp/zbx-compliance-distributions-no-tags-c98as5a.tmp

aws cloudfront list-distributions --query "DistributionList.Items[].ARN" --output json | grep -oP '(?<=").*(?=")' | while read distARN || [[ -n $distARN ]];
do
  echo 0 > $TEMPFILE
  aws cloudfront list-tags-for-resource --resource $distARN --query 'Tags' | jq -c '.Items[] | .key' | grep -oP '(?<=").*(?=")' | while read tags || [[ -n $tags ]];
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