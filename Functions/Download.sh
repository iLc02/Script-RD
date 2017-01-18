#!/bin/bash

echo ""
echo "***** Download *****"

### Converting the links and sending the downloads to your favorite download manager

# Creating a loop

start=0
while [ $start -lt $RDFinishedTorrents ]
do
start=$((start +1))

echo "----- Torrent n°$start -----"

OriginalLink=$(head -n 1 ./Files/RDTorrentsListLinks)

curl -s -X POST -H "Authorization: Bearer $RDtoken" -d link=$OriginalLink "https://api.real-debrid.com/rest/1.0/unrestrict/link" > ./Files/RDPublicLink

# Extracting json and formatting
cat ./Files/RDPublicLink | jq '. | .download' > ./Files/RDPublicLink2
mv ./Files/RDPublicLink2 ./Files/RDPublicLink
sed 's/^.//' ./Files/RDPublicLink > ./Files/RDPublicLink2
mv ./Files/RDPublicLink2 ./Files/RDPublicLink
sed 's/.$//' ./Files/RDPublicLink > ./Files/RDPublicLink2
mv ./Files/RDPublicLink2 ./Files/RDPublicLink

PublicLink=$(head -n 1 ./Files/RDPublicLink)

echo "Original Link : $OriginalLink"
echo "Generated Link : $PublicLink"


# From here you can do whatever you want with that public link, I'm sending it to my Synology Download Station
wget --quiet --load-cookies=./Cookies/cookies_Syno.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"  "http://$Syno_IP:5000/webapi/DownloadStation/task.cgi?api=SYNO.DownloadStation.Task&version=1&method=create&uri=$PublicLink"

# Removing the first line of the file
sed '1d' ./Files/RDTorrentsListLinks > ./Files/RDTorrentsListLinks2
mv ./Files/RDTorrentsListLinks2 ./Files/RDTorrentsListLinks

sleep 1;done

if (($start==0))
  then echo "No file was downloaded."
elif (($start==1))
  then echo ""
       echo "1 file was downloaded."
elif (($start>1))
  then echo "$start files were downloaded."
       echo ""
fi
