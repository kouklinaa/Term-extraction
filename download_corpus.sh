#!/bin/bash
# ------------------------------------------
INPUT=$1 # file path
OLDIFS=$IFS # separators
IFS=','


i=1 # intitialize count of rows

# open file
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

# loop through rows
while read id pdf html html_abby stades # read comumns
do
	echo i: $i
	echo "Name : $id"
	echo "HTML : $html"
	wget -p -k $html # download files
	echo ""
	((i++)) # increment count of rows
done < $INPUT

# show last row
echo "Last row : "
echo $id
echo $html
wget -p -k $html # download files

IFS=$OLDIFS
