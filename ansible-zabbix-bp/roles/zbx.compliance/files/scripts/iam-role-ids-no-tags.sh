#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-iam-roles-ids-no-tags-656asf5a654dsa.tmp

aws iam list-roles --query 'Roles[*].RoleName' --output json | grep -oP '(?<=").*(?=")' | while read roleName || [[ -n $roleName ]];
do
  echo 0 > $TEMPFILE
  aws iam list-role-tags --role-name $roleName --query 'Tags[*].Key' | grep -oP '(?<=").*(?=")' | while read tags || [[ -n $tags ]];
  do
    if [[ -v tagsVerify[$tags] ]]; then
      COUNTER=$[$(cat $TEMPFILE) + 1]
      echo $COUNTER > $TEMPFILE
    fi
  done
  if [[ $(cat $TEMPFILE) -ne $totalTags ]]; then
    /usr/bin/zabbix_sender -z $1 -s "AWS" -k iam-roles-ids-no-tag -o $roleName
  fi
done

if [ -f "$TEMPFILE" ]
then
  unlink $TEMPFILE
  rm -f $TEMPFILE
fi