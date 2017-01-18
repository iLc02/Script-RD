#!/bin/bash

echo ""
echo "***** Formatting *****"

### Formatting  RDTorrentsListLinks

# Removing [ and ]
sed 's/\(\[\|\]\)//g' ./Files/RDTorrentsListLinks > ./Files/RDTorrentsListLinks2
mv ./Files/RDTorrentsListLinks2 ./Files/RDTorrentsListLinks
# Removing "
sed 's/["]//g' ./Files/RDTorrentsListLinks > ./Files/RDTorrentsListLinks2
mv ./Files/RDTorrentsListLinks2 ./Files/RDTorrentsListLinks
# Deleting empty lines
sed '/^$/d' ./Files/RDTorrentsListLinks > ./Files/RDTorrentsListLinks2
mv ./Files/RDTorrentsListLinks2 ./Files/RDTorrentsListLinks
# Deleting first two spaces of every line
sed 's/^.//' ./Files/RDTorrentsListLinks > ./Files/RDTorrentsListLinks2
mv ./Files/RDTorrentsListLinks2 ./Files/RDTorrentsListLinks
sed 's/^.//' ./Files/RDTorrentsListLinks > ./Files/RDTorrentsListLinks2
mv ./Files/RDTorrentsListLinks2 ./Files/RDTorrentsListLinks

echo "The download links were formated"
