#!/usr/bin/env bash

export scriptDir="$PWD/""$(dirname $0)"
export dataDir=`readlink -f $scriptDir/../data/Cadvisor`
export uid=`id -u $USER`
export gid=`id -g $USER`

docker service create \
    --name cadvisor \
    --publish 8081:8080 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/,dst=/rootfs,readonly \
    --mount type=bind,src=/sys,dst=/sys,readonly \
    --mount type=bind,src=/var/run,dst=/var/run \
    --mount type=bind,src=/var/lib/docker/,dst=/var/lib/docker,readonly \
    --network cloud-net \
    google/cadvisor