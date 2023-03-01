send() {
    nc -q 0 $ip $1
}

receive() {
    nc -v -l $ip $1
}

store() {
    c=1
    echo "$1 $2 $3 $c" >>users.txt
    cat users.txt
}

login() {
    IFS=' '
    read -ra segment <<<"$data"

    input=$(realpath users.txt)
    while read -r line; do
        IFS=' '
        echo "$line"
        read -ra line_part <<<"$line"
        if [ "${line_part[0]}" == "${segment[1]}" ]; then
            pre_hash="${line_part[2]}"
            echo "${line_part[3]}" | send 9999
        fi

    done <"$input"

    message=$(nc -v -l $ip 8888)
    # shellcheck disable=SC2046
    last_hash=$(echo "$message" | shasum)
    if [ "$pre_hash" == "$last_hash" ]; then
        while read -r line; do
                IFS=' '
                read -ra line_part <<<"$line"
                if [ "${line_part[0]}" == "${segment[1]}" ]; then
                    (("${line_part[3]}" ++))
                    "${line_part[2]}" = $message
                    echo "access granted" | send 9999
                fi

            done <"$input"
    fi
}

manage() {
    IFS=' '
    read -ra ADDR <<<"$data"

    if [ "${ADDR[0]}" == "reg" ]; then
        echo "$data"
        store ${ADDR[1]} ${ADDR[2]} ${ADDR[3]}
    else
        login $data
    fi

}

getData() {
    data=$(receive $1)
    manage $data
}

ip=127.0.0.1
while true; do
    getData 8888
done
