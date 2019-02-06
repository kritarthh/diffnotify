#!/bin/bash

. utils.sh

# find correct name for cutycapt
CUTYCAPT=`compgen -c |grep -i CutyCapt`

# check if display available
if [[ "$DISPLAY" == "" ]]; then
    CUTYCAPT="xvfb-run -a -e /var/log/xvfb.log $CUTYCAPT"
fi

function simple_link {
    $CUTYCAPT --url=$1 \
              --out=$2 \
              --delay=5000 \
              --plugins=on \
              --javascript=on >> cutycapt.log 2>&1 && \
        echo "success" || \
            {
                echo "failure. ignoring..." && \
                    return 1;
            }
}

function aliexpress {
    ./aliexpress screenshot $1 >> aliexpress.log 2>&1
    if [[ $? -eq 0 ]]; then
        echo "success."
    else
        echo "failure."
        return;
    fi
}

function fetch {
    check_and_wait_for_internet 5
    link=$1
    screenshot_name=$2
    printf "fetch new result... "
    case "$link" in
        *trade.aliexpress.com*)
            echo "aliexpress link detected... using selenium driver."
            aliexpress $screenshot_name
            ;;
        *.17track.net* | "3")
            echo "17track.net link detected... using CutyCapt."
            simple_link $link $screenshot_name
            ;;
        *)
            echo "unrecognized link... using CutyCapt."
            simple_link $link $screenshot_name
            ;;
    esac
}
