#!/usr/bin/env bash

export scriptDir="$PWD/""$(dirname $0)"
export dataDir=`readlink -f $scriptDir/../data/Grafana`
export uid=`id -u $USER`
export gid=`id -g $USER`

docker service create \
    --name grafana \
    --publish 3000:3000 \
    --constraint 'node.role == manager' \
    --env GF_SECURITY_ADMIN_USER=${ADMIN_USER:admin} \
    --env GF_SECURITY_ADMIN_PASSWORD=${ADMIN_PASSWORD:admin} \
    --env GF_USERS_ALLOW_SIGN_UP=false \
    --mount type=bind,src=$scriptDir/config/datasources,dst=/etc/grafana/datasources \
    --mount type=bind,src=$scriptDir/config/dashboards,dst=/etc/grafana/dashboards \
    --mount type=bind,src=$scriptDir/config/setup.sh,dst=/setup.sh \
    --mount type=bind,src=$dataDir,dst=/var/lib/grafana \
    --mount type=bind,src=/etc/passwd,dst=/etc/passwd,readonly \
    --user $uid:$gid \
    --network cloud-net \
    grafana/grafana ./setup.sh