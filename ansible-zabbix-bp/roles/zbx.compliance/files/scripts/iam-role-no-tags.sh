#!/usr/bin/env bash

#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

declare -A tagsVerify=(['bp:negocio:nomeJornada']=, ['bp:negocio:nomeSquad']=, ['bp:tecnico:identificacaoDoServico']=, ['bp:tecnico:descricaoDoServico']=, ['bp:tecnico:ambiente']=)
declare -r totalTags=${#tagsVerify[@]}
declare -r TEMPFILE=/tmp/zbx-iam-roles-no-tags-sd65da56da.tmp
declare -r TEMPFILECOMPLIANCE=/tmp/zbx-compliance-iam-roles-no-tags-faffd6s5da.tmp

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