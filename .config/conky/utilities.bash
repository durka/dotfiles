calc() {
    printf "%.${2:-1}f" $(bc -l <<<"$1")
}

si_prefix() {
    if [ $(calc "$1>(500*1024)" 0) -eq 1 ]; then
        echo "$(calc "$1/1024/1024")G"
    elif [ $(calc "$1>500" 0) -eq 1 ]; then
        echo "$(calc "$1/1024")M"
    else
        echo "$(calc "$1")K"
    fi
}

