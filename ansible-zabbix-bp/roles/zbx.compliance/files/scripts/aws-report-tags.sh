#!/usr/bin/env bash

CSVFILE=/tmp/relatorio-no-tags-bp.csv

tagsVerify=('bp:negocio:nomeJornada' 'bp:negocio:nomeSquad' 'bp:tecnico:identificacaoDoServico' 'bp:tecnico:descricaoDoServico' 'bp:tecnico:ambiente')

declare -r totalTags=${#tagsVerify[@]}

function get_resource_compliance_line() {
  # $1 Type
  # $2 JSON
  # $3 aws cli list tag

  VALIDATION="$1"
  TYPE="$2"
  INPUT="$3"
  KEY="$4"

  case "$VALIDATION" in
	  2)
	  	TOTAL=$(echo "$INPUT" | jq -r '. | length')
	  	let TOTAL--
	  	LG=$(seq 0 $TOTAL)

	  	IFS=$'\n'
	  	;;
	  *)
	  	LG="$INPUT"
    		IFS=$'\t'
	  	;;
  esac

  # LG stands for Loop Geral
  for resource in $LG; do
	  echo "** $TYPE: $resource"

	  # Sair desse case com as variaveis SIZE e TAGS preenchidas
	  case "$VALIDATION" in
	  	# 1-ElasticBeansTalk,3-CloudFront,4-ECS
	  	1|3|4)
	  		ARN="$resource"
	  		RESULT=$(aws $KEY list-tags-for-resource --resource "$resource" --output json)
        if [ $VALIDATION -eq 1 ]; then
          TMPJQEXPRESSIONSIZE='.ResourceTags'
          TMPJQEXPRESSIONTAGS='.ResourceTags[].Key'
        elif [ $VALIDATION -eq 3 ]; then
          TMPJQEXPRESSIONSIZE='.Tags.Items'
          TMPJQEXPRESSIONTAGS='.Tags.Items[].Key'
        elif [ $VALIDATION -eq 4 ]; then
          TMPJQEXPRESSIONSIZE='.tags'
          TMPJQEXPRESSIONTAGS='.tags[].key'
        fi

	  		SIZE=$(echo "$RESULT" | jq "$TMPJQEXPRESSIONSIZE | length")
	  		TAGS=$(echo "$RESULT" | jq "$TMPJQEXPRESSIONTAGS" -r)
	  		;;
	  	# 2-ElasticIP,2-AMI
	  	2)
	  		NODE=$(echo "$INPUT" | jq ".[$resource]")
	  		SIZE=$(echo "$NODE" | jq '.Tags | length')
	  		ARN=$(echo "$NODE" | jq ".$KEY" -r)

	  		if [ "$SIZE" -gt 0 ]; then
	  			TAGS=$(echo "$NODE" | jq '.Tags[].Key' -r)
	  		fi
	  		;;
	  	# 5-IAM
	  	5)
        ARN="$resource"
        RESULT=$(aws $KEY list-role-tags --role-name "$resource" --output json)

        SIZE=$(echo "$RESULT" | jq '.Tags | length')
        TAGS=$(echo "$RESULT" | jq '.Tags[].Key' -r)
	  		;;
	  	# 6-LAMBDA
	  	6)
        ARN="$resource"
        RESULT=$(aws $KEY list-tags --resource "$resource" --output json)

        SIZE=$(echo "$RESULT" | jq '.Tags | length')
        TAGS=$(echo "$RESULT" | jq '.Tags | keys[]' -r)
        ;;
      *)
	  		echo "\"$VALIDATION\" não tratado"
	  		return
	  		;;
	  esac

	  echo "  => Achou Tags Total: $SIZE"

	  TMPTAGS=( ${tagsVerify[@]})

	  IFS=$'\n'

	  for tag in $TAGS; do
	  	#echo "  > $tag"
	  	for i in "${!TMPTAGS[@]}"; do
	  		#echo "  >> ${TMPTAGS[i]}"
	  		# Achou? remove da lista
	  		if [ "${TMPTAGS[i]}" == "$tag" ]; then
	  			unset 'TMPTAGS[i]'
	  		fi
	  	done
	  done

	  # Tem que ter chego com size 0
	  if [ ! "${#TMPTAGS[@]}" == 0 ]; then
	  	echo "  * Faltou as tags: ${TMPTAGS[@]}"
	  	write_csv "$TYPE" "$ARN" "$(printf "%s;" "${TMPTAGS[@]}")"
	  	continue
	  fi

	  echo "  >> OK <<"
  done
}

function get_awsconfig_compliance_all() {
  JSONTMP=$(aws configservice get-compliance-details-by-config-rule --config-rule-name compliance-no-tags --compliance-types NON_COMPLIANT --query 'EvaluationResults[].EvaluationResultIdentifier.EvaluationResultQualifier[]')

  TOTAL=$(echo $JSONTMP | jq '. | length' -r)
  let TOTAL--
  LG=$(seq 0 $TOTAL)

  for resource in $LG; do
    RESOURCETYPE=$(echo $JSONTMP | jq ".[$resource].ResourceType" -r)
    RESOURCEID=$(echo $JSONTMP | jq ".[$resource].ResourceId" -r)

    JSONHISTORY=$(aws configservice get-resource-config-history --resource-type $RESOURCETYPE --resource-id $RESOURCEID --earlier-time $(date +"%Y-%m-%d") --chronological-order Forward)

    SIZE=$(echo $JSONHISTORY | jq '.configurationItems[0].tags | length' -r)
    TAGS=$(echo $JSONHISTORY | jq '.configurationItems[0].tags | keys[]' -r)

    echo "  => Achou Tags Total: $SIZE"

    TMPTAGS=( ${tagsVerify[@]})

	  IFS=$'\n'

	  for tag in $TAGS; do
	  	#echo "  > $tag"
	  	for i in "${!TMPTAGS[@]}"; do
	  		#echo "  >> ${TMPTAGS[i]}"
	  		# Achou? remove da lista
	  		if [ "${TMPTAGS[i]}" == "$tag" ]; then
	  			unset 'TMPTAGS[i]'
	  		fi
	  	done
	  done

	  # Tem que ter chego com size 0
	  if [ ! "${#TMPTAGS[@]}" == 0 ]; then
	  	echo "  * Faltou as tags: ${TMPTAGS[@]}"
	  	write_csv "$(echo $RESOURCETYPE | cut -d : -f 3)" "$RESOURCEID" "$(printf "%s;" "${TMPTAGS[@]}")"
	  	continue
	  fi

    echo "  >> OK <<"
  done
}

function write_csv() {
  # $1 Type
  # $2 Name or ARN

  local TAGS="$3"
  local LINE="$1;$2;$TAGS"
  echo "  >- Printando pra csv |$LINE| -<"

  echo "$LINE" >> $CSVFILE
}

> $CSVFILE

# get_resource_compliance_line
# $1 - Tipo de validação
# $2 - Tipo do Recurso
# $3 - JSON de analise
# $4 - Key

# 1-ElasticBeansTalk,2-EIP|AMI,3-CloudFront,4-ECS,5-IAM,6-Lambda

get_resource_compliance_line 1 EBT "$(aws elasticbeanstalk describe-applications --query "Applications[].ApplicationArn" --output text)" 'elasticbeanstalk'
get_resource_compliance_line 2 EIP "$(aws ec2 describe-addresses --query 'Addresses[*]' --output json)" "PublicIp"
get_resource_compliance_line 2 AMI "$(aws ec2 describe-images --owners self --query 'Images[*]' --output json)" "ImageId"
get_resource_compliance_line 3 CFT "$(aws cloudfront list-distributions --query "DistributionList.Items[].ARN" --output text)" 'cloudfront'
get_resource_compliance_line 4 ECS "$(aws ecs list-clusters --query "clusterArns[*]" --output text)" 'ecs'
get_resource_compliance_line 5 IAM "$(aws iam list-roles --query 'Roles[*].RoleName' --output text)" 'iam'
get_resource_compliance_line 6 LBD "$(aws lambda list-functions --query 'Functions[*].FunctionArn' --output text)" 'lambda'
get_awsconfig_compliance_all