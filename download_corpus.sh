#!/bin/bash
# ------------------------------------------
INPUT=$1 # path to csv file
OLDIFS=$IFS
IFS=','


i=1 # start counting rows

# open file
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

# loop through rows
while read id pdf html html_abby stades # specify columns from the csv file
do
	echo i: $i # current number of the row
	echo "Name : $id" # column that contains specific ids of the bulletins
	echo "HTML : $html" # column that contains paths to html version of bulletins
	wget -p -k $html # save html pages
	echo ""
	((i++)) # increment the count
done < $INPUT

# show last row
echo "Last row : "
echo $id
echo $html
wget -p -k $html # download html

# move all html files to another location
mkdir ./resources/html_corpus
find . -name "*.html" -exec mv "{}" ./resources/html_corpus \;
rm -rf ontology.inrae.fr

IFS=$OLDIFS
