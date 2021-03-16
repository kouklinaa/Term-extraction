#!/bin/bash
# I. --------------------------------------------

INPUT=$1 # path to csv file
OLDIFS=$IFS
IFS=','
i=1 # start counting rows



# II. -------------------------------------------

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; } # open csv file

while read id pdf html html_abby stades # # loop through rows and columns
do
	echo i: $i # current number of the row
	echo "Name : $id" # column that contains specific ids of the bulletins
	echo "HTML : $html" # column that contains paths to html version of bulletins
	wget -p -k $html # save html pages
	echo ""
	((i++)) # increment the count
done < $INPUT


echo "Last row : "
echo $id
echo $html
wget -p -k $html # download last html

IFS=$OLDIFS


# III. ------------------------------------------
mkdir ./resources/html_corpus # move all html files to another location
find . -name "*.html" -exec mv "{}" ./resources/html_corpus \;
rm -rf ontology.inrae.fr
