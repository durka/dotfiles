#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

for line in $(ip addr | awk '-F[ /]+' '/(en|wlp|ppp|tun)[^ ]+$/ {print $NF "___" $3}')
do
    [[ "$line" =~ (.*)___(.*) ]] || continue
    if=${BASH_REMATCH[1]}
    ip=${BASH_REMATCH[2]}

    width=150
    if [[ $ip == "10.0.10."* ]]; then
        ifn="$if\${goto $width}Exyn"
    elif [[ $ip =~ 10\.(.*)\.0\. ]]; then
        ifn="$if\${goto $width}PFM${BASH_REMATCH[1]}"
    elif [[ $ip == "192.168.2."* ]]; then
        ssid=$(iwgetid --raw $if)
        if [[ $ssid =~ exyn-Robot(.*) ]]; then
            ifn="$if\${goto $width}R${BASH_REMATCH[1]}"
        else
            ifn="$if\${goto $width}AP"
        fi
    elif [[ $if == "tun"* ]] || [[ $if == "ppp"* ]]; then
        ifn="$if\${goto $width}VPN"
    else
        ifn=$if
    fi

    speeds=$(awk '{if(l1){print ($2-l1)*4/1024 "_" ($10-l2)*4/1024} else{l1=$2; l2=$10;}}' <(grep $if /proc/net/dev) <(sleep 0.25; grep $if /proc/net/dev))
    [[ "$speeds" =~ (.*)_(.*) ]] || continue
    down=${BASH_REMATCH[1]}
    up=${BASH_REMATCH[2]}

    echo "\${color}$ifn\${goto $(($width+65))}$ip\${color grey}\${goto $(($width+200))}Up:\$color $(si_prefix $up)Bps \${color grey}\${goto $(($width+330))}- Down:\$color $(si_prefix $down)Bps\${color grey}"
done

