#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

parse() {
    local data=$(grep "^$1:" <<<"$2")
    local total=$(awk '{print $2}' <<<"$data")
    local nf=$(awk '{print NF}' <<<"$data")
    if [ $nf -ge 5 ]; then
        local shared=$(awk '{print $5}' <<<"$data")
        local avail=$(awk '{print $7}' <<<"$data")
        local used=$(calc "$total-$avail-$shared")
    else
        local used=$(awk '{print $3}' <<<"$data")
    fi

    echo -n "Usage: \${color}$(si_prefix $used)/$(si_prefix $total)iB\${goto 270}$(printf "%02s" $(calc "$usegb/$totgb*100" 0))\${goto 291}%\${color grey}"
}

data=$(free -k)

echo -n '${color grey}RAM '
parse Mem "$data"
echo '${goto 325}${membar 4}'

echo -n '${color grey}Swap '
parse Swap "$data"
echo '${goto 325}${swapbar 4}'

