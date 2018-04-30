#!/usr/bin/env bash

export scriptDir="$PWD/""$(dirname $0)"
export dataDir=`readlink -f $scriptDir/../data/NodeExporter`
export uid=`id -u $USER`
export gid=`id -g $USER`

docker service create \
    --name nodeexporter \
    --publish 9100:9100 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/proc,dst=/host/proc,readonly \
    --mount type=bind,src=/sys,dst=/host/sys,readonly \
    --mount type=bind,src=/,dst=/rootfs,readonly \
    --network cloud-net \
    prom/node-exporter --path.procfs='/host/proc' \
    --path.sysfs='/host/sys' \
    --collector.filesystem.ignored-mount-points='^/(sys|proc|dev|host|etc)($$|/)'