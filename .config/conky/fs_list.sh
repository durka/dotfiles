#!/usr/bin/env bash

for line in $(mount | awk '/ext4|udisks2|sshfs/ {print $1 "_" $3 "_" $5}')
do
    IFS='_' read -ra parts <<<"$line"
    dev=${parts[0]}
    mp=${parts[1]}
    fs=${parts[2]}

    if [[ "$fs" == *"sshfs"* ]]; then
        IFS=':' read -ra parts <<<"$dev"
        name=${parts[0]}
    else
        name=$(lsblk -no LABEL $dev)
    fi

    echo "$name\${goto 150}\$color\${fs_used $mp}/\${fs_size $mp}\${goto 310}\${fs_bar 6 $mp}\${color grey}"
done

