#!/bin/bash

echo ""
echo "***** Adding Magnets *****"

cd $TorrentsFolder/MagnetFiles

### Calculating how many .torrent files are in the folder
LocalMagnets=$(\ls -afq *.magnet 2> /dev/null | wc -l)

if (($LocalMagnets==0))
  then echo "No magnet is waiting to be sent to Real-Debrid."
elif (($LocalMagnets==1))
  then echo "1 magnet is waiting to be sent to Real-Debrid."
elif (($LocalMagnets>1))
  then echo "$LocalMagnets magnets are waiting to be sent to Real-Debrid."
fi

# Calculating how many torrents we can send to Real Debrid

if ((LocalMagnets > RDAvailableSpots))
then
MagnetsToSend=$RDAvailableSpots
else
MagnetsToSend=$LocalMagnets
fi;

if (($RDAvailableSpots==0))
  then echo "No spot is available in Real-Debrid."
elif (($RDAvailableSpots==1))
  then echo "1 spot is available in Real-Debrid."
elif (($RDAvailableSpots>1))
  then echo "There are $RDAvailableSpots available spots in Real-Debrid."
fi

if (($MagnetsToSend==0))
  then echo "We are going to send $MagnetsToSend magnet to Real Debrid."
elif (($MagnetsToSend==1))
  then echo "We are going to send $MagnetsToSend magnet to Real Debrid."
elif (($MagnetsToSend>1))
  then echo "We are going to send $MagnetsToSend magnets to Real Debrid."
fi

### Sending the torrents to Real Debrid

start=0
while [ $start -lt $MagnetsToSend ]
do
start=$((start +1))

cd $TorrentsFolder/MagnetFiles

echo "---- Magnet n°$start ----"

# Renaming the oldest torrent "torrent.torrent"
ls -ltr *.magnet | awk '{ field = $NF }; END{ print field }' | xargs -I '{}' mv '{}' magnet.magnet

# Selecting magnet file content
MagnetLink=$(head -n 1 magnet.magnet)


### Sending torrent.torrent to Real Debrid

curl -X POST \
  -H "Authorization: Bearer $RDtoken" \
  -d magnet="$MagnetLink" \
  "https://api.real-debrid.com/rest/1.0/torrents/addMagnet" > $DIR/Files/AddMagnet

rm magnet.magnet

### Retrieving the ID of the torrent that we just sent
cd $DIR
cat ./Files/AddMagnet | jq '. | .id' > ./Files/AddMagnetID

# Reformating from "XXXXXXXXX" to XXXXXXXXX

# Removing first "
sed 's/^.//' ./Files/AddMagnetID > ./Files/AddMagnetID2
mv ./Files/AddMagnetID2 ./Files/AddMagnetID
# Removing last "
sed 's/.$//' ./Files/AddMagnetID > ./Files/AddMagnetID2
mv ./Files/AddMagnetID2 ./Files/AddMagnetID

# Selecting all the files of torrents
SelectedID=$(head -n 1 ./Files/AddMagnetID)
curl -X POST -H "Authorization: Bearer $RDtoken" -d files="all" "https://api.real-debrid.com/rest/1.0/torrents/selectFiles/$SelectedID" > ./Files/TorrentSelectFiles;done

# Removing the files we created

cd $DIR/Files
rm * 2> /dev/null

if (($start==0))
  then echo "No magnet was added."
elif (($start==1))
  then echo ""
       echo "1 magnet was added."
elif (($start>1))
  then echo "$start magnets were added."
       echo ""
fi
