function notify {
    printf "notify... "
    response=`curl --request POST \
      --url https://api.voice.plivo.com/v1/Account/MASWVLYTS4ZSU1YTY4XT/Call/ \
      --header 'authorization: Basic TDHJKDSdjsafhjkHFDKS==' \
      --header 'content-type: application/json' \
      --data '{
            "from": "919717000000",
            "to": "919717000001",
            "answer_url": "https://gist.github.com/kritarthh/e378343e62007938272beeb42a4c4e9f/raw/e787a5f6548df3c5bca699fefac12341d0606668/speak_change",
            "answer_method": "GET",
            "ring_timeout": "60"
        }' 2> /dev/null`
    printf "success.\n$response\n"
}
