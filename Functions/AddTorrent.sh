#!/bin/bash

echo ""
echo "***** Adding Torrents *****"

cd $TorrentsFolder/TorrentFiles

### Calculating how many .torrent files are in the folder
LocalTorrents=$(\ls -afq *.torrent 2> /dev/null | wc -l)

if (($LocalTorrents==0))
  then echo "No torrent is waiting to be sent to Real-Debrid."
elif (($LocalTorrents==1))
  then echo "1 torrent is waiting to be sent to Real-Debrid."
elif (($LocalTorrents>1))
  then echo "$LocalTorrents torrents are waiting to be sent to Real-Debrid."
fi

# Calculating how many torrents we can send to Real Debrid

if ((LocalTorrents > RDAvailableSpots))
then
TorrentsToSend=$RDAvailableSpots
else
TorrentsToSend=$LocalTorrents
fi;

if (($RDAvailableSpots==0))
  then echo "No spot is available in Real-Debrid."
elif (($RDAvailableSpots==1))
  then echo "1 spot is available in Real-Debrid."
elif (($RDAvailableSpots>1))
  then echo "There are $RDAvailableSpots available spots in Real-Debrid."
fi

if (($TorrentsToSend==0))
  then echo "We are going to send $TorrentsToSend torrent to Real Debrid."
elif (($TorrentsToSend==1))
  then echo "We are going to send $TorrentsToSend torrent to Real Debrid."
elif (($TorrentsToSend>1))
  then echo "We are going to send $TorrentsToSend torrents to Real Debrid."
fi

### Sending the torrents to Real Debrid

start=0
while [ $start -lt $TorrentsToSend ]
do
start=$((start +1))

cd $TorrentsFolder/TorrentFiles

echo "---- Torrent n°$start ----"
# Renaming the oldest torrent "torrent.torrent"

ls -ltr *.torrent | awk '{ field = $NF }; END{ print field }' | xargs -I '{}' mv '{}' torrent.torrent

### Sending torrent.torrent to Real Debrid
curl --silent -X PUT -H "Authorization: Bearer $RDtoken" -d host=real-debrid.com -d split=30 --upload-file torrent.torrent "https://api.real-debrid.com/rest/1.0/torrents/addTorrent" > $DIR/Files/AddTorrent

sleep 2

rm torrent.torrent

### Retrieving the ID of the torrent that we just sent
cd $DIR
cat ./Files/AddTorrent | jq '. | .id' > ./Files/AddTorrentID

# Reformating from "XXXXXXXXX" to XXXXXXXXX

# Removing first "
sed 's/^.//' ./Files/AddTorrentID > ./Files/AddTorrentID2
mv ./Files/AddTorrentID2 ./Files/AddTorrentID
# Removing last "
sed 's/.$//' ./Files/AddTorrentID > ./Files/AddTorrentID2
mv ./Files/AddTorrentID2 ./Files/AddTorrentID

# Selecting all the files of torrents
SelectedID=$(head -n 1 ./Files/AddTorrentID)
curl -X POST -H "Authorization: Bearer $RDtoken" -d files="all" "https://api.real-debrid.com/rest/1.0/torrents/selectFiles/$SelectedID" > ./Files/TorrentSelectFiles

sleep 2;done

# Removing the files we created

cd $DIR/Files
rm * 2> /dev/null

if (($start==0))
  then echo "No torrent was added."
elif (($start==1))
  then echo ""
       echo "1 torrent was added."
elif (($start>1))
  then echo "$start torrents were added."
       echo ""
fi
