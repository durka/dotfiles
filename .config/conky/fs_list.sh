#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

throttle 10

names=()

while read -r line
do
    IFS='#' read -ra parts <<<"$line"
    dev="${parts[0]}"
    mp="${parts[1]}"
    fs="${parts[2]}"

    if [[ "$fs" == *"sshfs"* ]]; then
        IFS=':' read -ra parts <<<"$dev"
        name="$(basename "${parts[1]}")"
    else
        name="$(lsblk -no LABEL "$dev")"
        if [[ "x$name" == "x" ]]; then
            name="$mp"
        fi
    fi

    if [[ " ${names[@]} " =~ " ${name} " ]]; then
        # did this one already (FS mounted at two places)
        continue
    else
        names+=("$name")
    fi

    df=$(df -h "$mp" --output=used,size | tail -1)
    used=$(awk '{print $1}' <<<"$df")
    size=$(awk '{print $2}' <<<"$df")

    echo "$name\${goto 150}\${color}$used/${size}iB\${goto 310}\${fs_bar 6 "$mp"}\${color grey}"
done < <(mount | rg 'ext4|vfat|fuseblk|udisks2|sshfs' | sed 's/\(.*\) on \(.*\) type \(.*\) (.*/\1#\2#\3/')

