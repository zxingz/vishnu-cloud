#!/usr/bin/env bash

export scriptDir="$PWD/""$(dirname $0)"
export dataDir=`readlink -f $scriptDir/../data/Prometheus`
export uid=`id -u $USER`
export gid=`id -g $USER`

docker service create \
    --name prometheus \
    --publish 9090:9090 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=$scriptDir/config/,dst=/etc/prometheus/ \
    --mount type=bind,src=$dataDir,dst=/prometheus \
    --mount type=bind,src=/etc/passwd,dst=/etc/passwd,readonly \
    --user $uid:$gid \
    --network cloud-net \
    prom/prometheus