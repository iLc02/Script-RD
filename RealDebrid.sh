#!/bin/bash

######## variables list (default) : $TorrentsFolder $RDtoken $RDMaxTorrents (20) $MaximumSpots (20) $Syno_IP $Syno_User $Syno_Pass


# To run this script, you need JQ, curl, wget installed
# To install them, run the command "sudo apt-get install curl wget jq"

echo ""
echo "***** Real-Debrid script *****"

### Find the folder where the script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "The script is located $DIR"
cd $DIR

### Variables Definition



#RD currently allows a maximum of 20 simultaneous active torrents. If you want to keep spots for manually adding torrents, you can lower this variable

# To get your token, visit : https://real-debrid.com/apitoken


### Creating the folders
mkdir Files Logs 2> /dev/null

### Retrieving Torrent list and status
curl -s -X GET -H "Authorization: Bearer $RDtoken" "https://api.real-debrid.com/rest/1.0/torrents" > ./Files/RDTorrentsList
echo "Torrent list and status copied into file Files/RDTorrentsList"

### Script Functions

# Counting the torrents
. $DIR/Functions/Counting.sh

# Removing all the finished torrents from RD
. $DIR/Functions/Cleanup.sh

# Formating the links in RDFinishedTorrentsLinks
. $DIR/Functions/LinksFormatting.sh

# Downloading the files
. $DIR/Functions/Download.sh

# Cleaning the files
rm ./task* ./RD* 2> /dev/null

# Formatting torrent & magnet files
. $DIR/Functions/TorrentFormatting.sh

# Adding new torrent files
. $DIR/Functions/AddTorrent.sh

# Adding new magnet files
. $DIR/Functions/AddMagnet.sh

echo ""
