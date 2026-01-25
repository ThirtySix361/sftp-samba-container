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

#######################################################################################

info "started"

docker build -t "$imagename" "$basedir/src/"
docker system prune -f

info "finished"

#######################################################################################
