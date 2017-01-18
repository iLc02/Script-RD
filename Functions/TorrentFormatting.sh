#!/bin/bash

echo ""
echo "***** Formatting Torrents *****"

#Creating folders
mkdir $TorrentsFolder/TorrentFiles 2> /dev/null
mkdir $TorrentsFolder/MagnetFiles 2> /dev/null

#Deleting spaces and special characters in filenames
#rename "/[-_ ]//g" *
#mv * $(echo 'file' | sed -e 's/[^A-Za-z0-9._-]/_/g')

cd $TorrentsFolder

rename 's/[^a-zA-Z0-9_.]//g' *

#Moving files to their folders
mv *.torrent ./TorrentFiles 2> /dev/null
mv *.magnet ./MagnetFiles 2> /dev/null

echo "Torrents were formated"
