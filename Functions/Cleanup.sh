#!/bin/bash

echo ""
echo "***** Cleanup *****"

### Removing every torrent ready for download from Real Debrid with the ID

# Format "XXXXXXXXX" so we need to remove the first " and the last " of every line

# First "
sed 's/^.//' ./Files/RDTorrentsListID > ./Files/RDTorrentsListID2
mv ./Files/RDTorrentsListID2 ./Files/RDTorrentsListID

# Last "
sed 's/.$//' ./Files/RDTorrentsListID > ./Files/RDTorrentsListID2
mv ./Files/RDTorrentsListID2 ./Files/RDTorrentsListID

# Loop for every torrent that we are removing

if (($RDFinishedTorrents==0))
  then echo "No torrent is ready to be removed."
elif (($RDFinishedTorrents==1))
  then echo "1 torrent is ready to be removed."
elif (($RDFinishedTorrents>1))
  then echo " $RDFinishedTorrents torrents are ready to be removed."
fi

start=0
while [ $start -lt $RDFinishedTorrents ]
do
start=$((start +1))

IDtoremove=$(head -n 1 ./Files/RDTorrentsListID)
echo "$IDtoremove will be removed."

# Removing the torrent from RD
curl -X DELETE -H "Authorization: Bearer $RDtoken" "https://api.real-debrid.com/rest/1.0/torrents/delete/$IDtoremove"

# Deleting first line of file
sed '1d' ./Files/RDTorrentsListID > ./Files/RDTorrentsListID2
mv ./Files/RDTorrentsListID2 ./Files/RDTorrentsListID;done

if (($start==0))
  then echo "No torrent was removed from RD."
elif (($RDFinishedTorrents==1))
  then echo "1 torrent was removed from RD."
elif (($RDFinishedTorrents>1))
  then echo " $RDTotalTorrents torrents were removed from RD."
fi
