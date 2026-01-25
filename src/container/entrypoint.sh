#!/bin/bash

set -e

info() { command echo $(date +"%Y-%m-%d %H:%M:%S") [INFO] "$0": "$@" >&2 ; }
error() { command echo $(date +"%Y-%m-%d %H:%M:%S") [ERROR] "$0": "$@" >&2; }

#######################################################################################

basedir=$(dirname "$(realpath $0)")
basefile=$(basename "$(realpath $0)")
basepath=$basedir/$basefile

#######################################################################################

if ! id "$NAS_USER" >/dev/null 2>&1; then
    useradd -m -s /usr/sbin/nologin "$NAS_USER"
    echo "$NAS_USER:$NAS_PASSWORD" | chpasswd
fi

if ! pdbedit -L | grep -q "^${NAS_USER}:"; then
    echo -e "${NAS_PASSWORD}\n${NAS_PASSWORD}" | smbpasswd -a -s "${NAS_USER}"
fi

#######################################################################################

cat >> /etc/ssh/sshd_config <<EOF
Port 22
Subsystem sftp internal-sftp

Match User $NAS_USER
    ChrootDirectory /data/
    ForceCommand internal-sftp -d /$NAS_NAME
    PasswordAuthentication yes
    PubkeyAuthentication no
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
EOF

cat > /etc/samba/smb.conf <<EOF
[global]
    security = user

[$NAS_NAME]
    path = /data/$NAS_NAME/
    valid users = $NAS_USER
    read only = no
EOF

#######################################################################################

mkdir -p /data/$NAS_NAME/
chmod 755 /data/
chmod 777 /data/$NAS_NAME/

#######################################################################################

/usr/sbin/smbd -F --debug-stdout -d 3 &
SMBD_PID=$!

/usr/sbin/sshd -D -e &
SSHD_PID=$!

wait -n $SMBD_PID $SSHD_PID

error "One service exited, stopping container"
exit 1
