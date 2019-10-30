#!/usr/bin/env bash

for line in $(ip addr | awk '-F[ /]+' '/(enp|wlp)[^ ]+$/ {print $NF "___" $3}')
do
    [[ "$line" =~ (.*)___(.*) ]] || continue
    if=${BASH_REMATCH[1]}
    ip=${BASH_REMATCH[2]}

    echo "\${color}$if\${goto 100}$ip\${color grey}\${goto 250}Up:\$color \${upspeed $if} \${color grey}\${goto 350}- Down:\$color \${downspeed $if}\${color grey}"
done

