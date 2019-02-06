function check_and_wait_for_internet {
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "online. continue."
    else
        echo "offline. retry after $1s."
        sleep $1
        check_and_wait_for_internet $1
    fi
}
