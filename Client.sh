send() {
    nc -q 0 -v $ip 8888
}

receive() {
    nc -l $ip
}

calculate() {
    #n=$(5 - $message)
    n=4
    count=$n
    pass="$password"
    while [ $count -ge 1 ]; do
        pass=$(echo "$pass" | shasum)
        #pass="$(shasum "$password")"
        ((count--))
    done
    echo "$pass" | send
}

register() {
    echo "-----REGISTER -----"
    echo -n "Login: "
    read username
    printf "Password: "
    read -s password | shasum >password

    n=5
    count=$n
    while [ $count -ge 1 ]; do
        password="$(cat password | shasum)"
        ((count--))
    done

    pass=$(cat password)
    echo
    data="reg $username $n $pass"
    echo "$data" | send
}

login() {
    echo "-----LOGIN -----"
    echo -n "Login: "
    read username
    echo -n "Password: "
    read -s password
    echo
    echo "log $username" | send
    message=$(nc -l $ip 9999)
    calculate $message $password
    answer=$(nc -l $ip 9999)
    echo "$answer"
}

menu() {
    echo "======  Lab: Shell Programming (BS)  ======"
    echo
    echo "  r   Register"
    echo "  l   Login"
    echo "  q   Quit"
    echo
    echo -n "your choice: "
    read choice

    echo
    case "$choice" in

    r) register ;;
    l) login ;;
    q) exit 0 ;;
    esac
}

ip=127.0.0.1
while true; do
    menu
done
