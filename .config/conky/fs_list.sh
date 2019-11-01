#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

for line in $(mount | awk '/ext4|udisks2|sshfs/ {print $1 "_" $3 "_" $5}')
do
    IFS='_' read -ra parts <<<"$line"
    dev=${parts[0]}
    mp=${parts[1]}
    fs=${parts[2]}

    if [[ "$fs" == *"sshfs"* ]]; then
        IFS=':' read -ra parts <<<"$dev"
        name=${parts[1]}
    else
        name=$(lsblk -no LABEL $dev)
    fi

    df=$(df -h $mp --output=used,size | tail -1)
    used=$(awk '{print $1}' <<<"$df")
    size=$(awk '{print $2}' <<<"$df")

    echo "$name\${goto 150}\${color}$used/${size}iB\${goto 310}\${fs_bar 6 $mp}\${color grey}"
done

