receive(){
    nc -l $ip 9999
}

readParams(){
    i=1
    j=$#
    while [ $i -le $j ]
    do
        printf " $1 "
        i=$((i+1))
        shift 1
    done
    echo
}

send(){
    nc -q 0 $ip 8888
}

#MAIN
ip=$1
readParams "$@" | send $ip
receive