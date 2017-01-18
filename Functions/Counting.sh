#!/bin/bash

echo ""
echo "***** Counting *****"

# Defining how many spots you want to use for this script


# Retrieving status and links of completed torrents
cat ./Files/RDTorrentsList | jq '.[] | select(.status=="downloaded") | .links' > ./Files/RDTorrentsListLinks
cat ./Files/RDTorrentsList | jq '.[] | select(.status=="downloaded") | .id' > ./Files/RDTorrentsListID

###################################################################

### Comptage du nombre de torrents à partir de l'ID

RDTotalTorrents=$(cat ./Files/RDTorrentsList | jq '.[] | .id' | wc -l)
RDFinishedTorrents=$(cat ./Files/RDTorrentsListID | wc -l)
RDActiveTorrents=$((RDTotalTorrents-RDFinishedTorrents))
RDAvailableSpots=$((MaximumSpots-RDActiveTorrents))

echo "We are going to use a maximum of $MaximumSpots spots in Real-Debrid."


if (($RDTotalTorrents==0))
  then echo "There is no torrent in Real-Debrid at the moment."
elif (($RDTotalTorrents==1))
  then echo "There is 1 torrent in Real-Debrid at the moment."
elif (($RDTotalTorrents>1))
  then echo "There are $RDTotalTorrents torrents in Real-Debrid at the moment."
fi

if (($RDAvailableSpots==0))
  then echo "No spot is available."
elif (($RDAvailableSpots==1))
  then echo "1 spot is available."
elif (($RDAvailableSpots>1))
  then echo "$RDAvailableSpots spots are available."
fi

if (($RDFinishedTorrents==0))
  then echo "No torrent is ready to be downloaded."
elif (($RDFinishedTorrents==1))
  then echo "1 torrent is ready to be downloaded."
elif (($RDTotalTorrents>1))
  then echo "$RDTotalTorrents torrents are ready to be downloaded."
fi

if (($RDActiveTorrents==0))
  then echo "No torrent is active."
elif (($RDActiveTorrents==1))
  then echo "1 torrent is still active."
elif (($RDActiveTorrents>1))
  then echo "$RDActiveTorrents torrents are still active."
fi
