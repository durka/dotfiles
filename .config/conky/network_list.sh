#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

for line in $(ip addr | awk '-F[ /]+' '/(enp|wlp|ppp)[^ ]+$/ {print $NF "___" $3}')
do
    [[ "$line" =~ (.*)___(.*) ]] || continue
    if=${BASH_REMATCH[1]}
    ip=${BASH_REMATCH[2]}

    if [[ $ip == "10.0.10."* ]]; then
        ifn="$if\${goto 100}Exyn"
    elif [[ $ip =~ 10\.(.*)\.0\. ]]; then
        ifn="$if\${goto 100}PFM${BASH_REMATCH[1]}"
    elif [[ $ip == "192.168.2."* ]]; then
        ssid=$(iwgetid --raw $if)
        if [[ $ssid =~ exyn-Robot(.*) ]]; then
            ifn="$if\${goto 100}R${BASH_REMATCH[1]}"
        else
            ifn="$if\${goto 100}AP"
        fi
    else
        ifn=$if
    fi

    speeds=$(awk '{if(l1){print ($2-l1)*4/1024 "_" ($10-l2)*4/1024} else{l1=$2; l2=$10;}}' <(grep $if /proc/net/dev) <(sleep 0.25; grep $if /proc/net/dev))
    [[ "$speeds" =~ (.*)_(.*) ]] || continue
    down=${BASH_REMATCH[1]}
    up=${BASH_REMATCH[2]}

    echo "\${color}$ifn\${goto 165}$ip\${color grey}\${goto 300}Up:\$color $(si_prefix $up)Bps \${color grey}\${goto 430}- Down:\$color $(si_prefix $down)Bps\${color grey}"
done

