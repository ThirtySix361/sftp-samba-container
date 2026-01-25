#!/bin/bash

info() { command echo $(date +"%Y-%m-%d %H:%M:%S") [INFO] "$0": "$@" >&2 ; }
error() { command echo $(date +"%Y-%m-%d %H:%M:%S") [ERROR] "$0": "$@" >&2; }

#######################################################################################

basedir="$(dirname "$(realpath "$0")")"
filename="$(basename "$(realpath "$0")")"
filename_noExt="${filename%.*}"
fullpath="${basedir}/${filename}"

#######################################################################################

if [ -f "$(dirname "$0")/_env.sh" ]; then
    source "$(dirname "$0")/_env.sh"
else
    echo "_env.sh not found, exiting"
    exit 1
fi

imagename="$IMAGE_NAME"
innerports=($INNER_PORTS)
containername="$CONTAINER_NAME"
containerports=($CONTAINER_PORTS)
name=$NAME
user=$USER
pass=$PASS

#######################################################################################

if [ -z "$1" ]; then
    ports=("${containerports[@]}")
else
    ports=($1)
fi

if [ -z "$2" ]; then
    mountpath="$basedir/mnt/"
else
    mountpath="$2"
fi

if [ -n "$3" ]; then
    name="$3"
fi

if [ -n "$4" ]; then
    if [[ "$4" == *:* ]]; then
        user=$(echo "$4" | cut -d':' -f1);
        pass=$(echo "$4" | cut -d':' -f2);
    else
        remove_only=true
    fi
fi

#######################################################################################

containersuffix="$(printf '%s-' "${ports[@]}" | sed 's/-$//')"

final_ports=()
for i in "${!innerports[@]}"; do
    if [ -n "${ports[$i]}" ]; then
        final_ports[$i]="${ports[$i]}"
    else
        final_ports[$i]="${containerports[$i]}"
    fi
done

port_args=""
for i in "${!innerports[@]}"; do
    port_args="$port_args -p ${final_ports[$i]}:${innerports[$i]}"
done

#######################################################################################

if docker inspect "${containername}_${containersuffix}" > /dev/null 2>&1; then
    docker rm -f "${containername}_${containersuffix}" > /dev/null 2>&1
    info "container ${containername}_${containersuffix} undeployed"
# else
#     error "failed to undeploy container container on port $port"
#     error "container on port $port does not exist"
fi

#######################################################################################

if [ -n "$remove_only" ]; then exit 1; fi

mkdir -p $mountpath
chmod 755 $mountpath
mkdir -p "${mountpath}/${name}"
chmod 777 "${mountpath}/${name}"

#######################################################################################

if ! docker network inspect network >/dev/null 2>&1; then
    docker network create network 2>&1
    info "Docker network 'network' created"
fi

#######################################################################################

response=$(docker run -d --restart unless-stopped --net=network --name "${containername}_${containersuffix}" \
    $port_args \
    -e NAS_NAME=$name \
    -e NAS_USER=$user \
    -e NAS_PASSWORD=$pass \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v $mountpath:/data/ \
    $imagename 2>&1)

if [ $? -eq 0 ]; then
    info "container ${containername}_${containersuffix} deployed"
else
    error "failed to deploy container ${containername}_${containersuffix}"
    error $response
fi

#######################################################################################
