# performs floating point calculation in $1 (with $2 decimal places, default 1)
calc() {
    printf "%.${2:-1}f" $(bc -l <<<"$1")
}

# takes a number of Kwhatevers and outputs nK or (n/1024)M or (n/1024/1024)G
# pass zero for second arg to omit K/M/G
si_prefix() {
    if [ $(calc "$1>(500*1024)" 0) -eq 1 ]; then
        suffix=G
        echo -n "$(calc "$1/1024/1024")"
    elif [ $(calc "$1>500" 0) -eq 1 ]; then
        echo -n "$(calc "$1/1024")"
        suffix=M
    else
        echo -n "$(calc "$1")"
        suffix=K
    fi
    
    if [ $# -eq 1 ] || [ $2 -ne 0 ]; then
        echo $suffix
    fi
}

# only runs the rest of the script every $1 seconds, otherwise outputs automatically cached output
throttle() {
    local stampfile=/tmp/$(basename $0).timestamp
    local cachefile=/tmp/$(basename $0).cache
    local now=$(date +%s)

    # check if we can use the cache or not
    if [ ! -f $stampfile ]; then
        # init
        echo $now >$stampfile
    else
        local stamp=$(<$stampfile)
        if [ $(calc "$now-$stamp" 0) -lt $1 ]; then
            # cache is still good, just print it and done
            cat $cachefile
            exit
        else
            # cache is expired
            echo $now >$stampfile
            rm $cachefile
        fi
    fi

    # redirect stdout so the rest of the script output will go to cache
    # use another fd to remember the original value of stdout
    exec 3>&1 1>$cachefile

    # this will be called when the script is done
    throttle_finish() {
        # restore stdout
        exec 1>&3

        # print cache (which has just been refreshed)
        cat $1
    }
    trap "throttle_finish $cachefile" EXIT
}

