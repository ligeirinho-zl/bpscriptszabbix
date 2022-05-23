#!/bin/bash

# todo mudar logica para trazer o nome
#bp:negocio:nomeJornada
#bp:negocio:nomeSquad
#bp:tecnico:identificacaoDoServico
#bp:tecnico:descricaoDoServico
#bp:tecnico:ambiente

###############################################################################
#################################  Maxmilhas  #################################
# Script created by Cloud and Monitoring Team - 2020
# Usage example:
###############################################################################
###############################################################################

# todo: implementar logica parecida mas somente para 

tagsVerify=('bp:negocio:nomeJornada', 'bp:negocio:nomeSquad', 'bp:tecnico:identificacaoDoServico', 'bp:tecnico:descricaoDoServico', 'bp:tecnico:ambiente')
lista=$(aws s3 ls | wc -l)
for output in $(aws s3 ls | cut -c20-80)
do
  aws s3api get-bucket-tagging --bucket $output 2> /dev/null | jq -c '.[][] | (.Key)' | grep -oP '(?<=").*(?=")' | while read line || [[ -n $line ]];
  do
    if ! [[ ${tagsVerify[*]} =~ "$line" ]]; then
	echo $output
	break
    fi
  done
done
