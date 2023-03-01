send(){
    nc -q 0 $ip 9999
}

receive(){
    #nc -vv -l "$ip" 8888
    message=$(nc -q 0 -l "$ip" 8888)
    echo $message
    echo $message | send
}

#MAIN
ip=127.0.0.1
while true
do
    receive $ip
done