#!/usr/bin/env bash

export scriptDir="$PWD/""$(dirname $0)"
export dataDir=`readlink -f $scriptDir/../data/Portainer`
export uid=`id -u $USER`
export gid=`id -g $USER`

docker service create \
    --name portainer \
    --publish 9000:9000 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
    --mount type=bind,src=$dataDir,dst=/data \
    --mount type=bind,src=/etc/passwd,dst=/etc/passwd,readonly \
    --user $uid:$gid \
    --network cloud-net \
    portainer/portainer \
    -H unix:///var/run/docker.sock