#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "The script is located $DIR"
cd $DIR

mkdir Cookies 2> /dev/null

# Se logguer sur le Syno

wget --save-cookies ./Cookies/cookies_Syno.txt --keep-session-cookies \
  "http://$Syno_IP:5000/webapi/auth.cgi?api=SYNO.API.Auth&version=2&method=login&account=$Syno_User&passwd=$Syno_Pass&session=DownloadStation&format=cookie"

rm auth.*
