#!/bin/bash

. fetch.sh
. notify.sh

MODE="$1"
LINK="$2"

START_X_FRACTION="$3"
START_Y_FRACTION="$4"
END_X_FRACTION="$5"
END_Y_FRACTION="$6"

MIN_NOTIFY_THRESH="$7"
MAX_NOTIFY_THRESH="50.0"

# create files and directories if no present
[ -d archive ] || mkdir -p archive
[ -f link_history ] || touch link_history

# map the link to a hash
hash=`md5sum <<< $LINK |cut -d' ' -f1`

[[ "$MODE" == "test" ]] && {
    fetch $LINK $hash.png
    ./imgtools test $hash.png $hash.png $START_X_FRACTION $START_Y_FRACTION $END_X_FRACTION $END_Y_FRACTION
    exit $?;
}

# save only if new link
[[ `grep -c "${hash},${LINK}" link_history` -eq 0 ]] && \
    echo $hash,$LINK >> link_history

function archive_and_move {
    mv ${hash}_old.png archive/${hash}_`date +%F_%T.%N`.png
    mv ${hash}_new.png ${hash}_old.png
}

function compare {
    # check if the old result exists
    # proceed if it does otherwise save the new result as old and return
    [ -f ${hash}_old.png ] || {
        echo "first attempt, saving as reference..." && \
            mv ${hash}_new.png ${hash}_old.png && \
            return 0;
    }

    # compare with the old result
    per_diff=`./imgtools diff ${hash}_old.png ${hash}_new.png $START_X_FRACTION $START_Y_FRACTION $END_X_FRACTION $END_Y_FRACTION`
    echo "difference is $per_diff %"

    # notify based on certain conditions
    if (( $(echo "$per_diff > $MIN_NOTIFY_THRESH" |bc -l) && \
              $(echo "$per_diff < $MAX_NOTIFY_THRESH" |bc -l) )); then
        notify "$per_diff"
    fi

    # archive the old result only if some difference found and save the new result as old
    if (( $(echo "$per_diff > 0.0" |bc -l) )); then
        archive_and_move
    else
        mv ${hash}_new.png ${hash}_old.png
    fi
    return 0
}

while true; do
    fetch $LINK ${hash}_new.png
    if [[ $? -eq 0 ]]; then
        compare
    else
        echo "error fetching new result..."
    fi
    echo "sleeping for 20 minutes..."
    sleep 1200
done
