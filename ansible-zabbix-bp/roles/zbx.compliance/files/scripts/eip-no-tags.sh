#!/usr/bin/env bash

total=$(`dirname "$0"`/eip-total.sh)

compliance=$(aws ec2 describe-addresses \
  --filters Name=tag:'bp:negocio:nomeJornada' \
  Name=tag:'bp:negocio:nomeSquad' \
  Name=tag:'bp:tecnico:identificacaoDoServico' \
  Name=tag:'bp:tecnico:descricaoDoServico' \
  Name=tag:'bp:tecnico:ambiente' \
  --query "Snapshots[*].SnapshotId" | grep " " | wc -l)

echo "$(expr $total - $compliance)"