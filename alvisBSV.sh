#!/bin/bash


# corpus
D2KAB=resources/corpus/d2kab/
VESPA=resources/corpus/vespa/
ALEA=resources/corpus/alea/

# html segmentation 
STYLESHEET=resources/alvisnlp/segmentation/html2alvisnlp.xslt

# referentiels
FCU=resources/referentiels/frenchCropUsage_20210525.rdf
PPDO=resources/referentiels/ppdo_20210726.rdf

# tomap files
MAPPINGFILE=resources/alvisnlp/tomap/frenchCropUsage_20210525.txt
CANDIDATEFILE=resources/alvisnlp/tomap/frenchCropUsage_20210525.tomap


# -------------------------change these paths to your local paths------------------------



# treetagger 
TREETAGGER=/Users/belka/Documents/work/inrae/outils/tree-tagger/bin/tree-tagger
PARFILE=/Users/belka/Documents/work/inrae/outils/tree-tagger/lib/french.par


#tomap 
PERLLIB=/Users/belka/Documents/work/inrae/outils/alvisnlp/YaTeA/lib/perl5/site_perl
YATEA=/Users/belka/Documents/work/inrae/outils/alvisnlp/YaTeA/local/bin/yatea
RCFILE=/Users/belka/Documents/work/inrae/outils/alvisnlp/YaTeA/etc/yatea/yatea.rc
CONFIGDIR=/Users/belka/Documents/work/inrae/outils/alvisnlp/YaTeA/usr/share/YaTeA/config
LOCALEDIR=/Users/belka/Documents/work/inrae/outils/alvisnlp/YaTeA/usr/share/YaTeA/locale



# --------------------------------------------------------------------------------------


if [ -z "$1" ]
then
	echo ""
	echo "No argument provided."
	echo "Please, choose an option :"
	echo "	-tomap-train"
	echo "	-annotate"
	echo "	-visualize"
	echo ""



elif [ $1 = "-tomap-train" ]
then 

	# create a mapping file (list of candidates for tomap-train)
	python algos/export/rdf2tabular.py $FCU > $MAPPINGFILE;


	# calculate syntaxic heads for the candidates from the mapping file
	alvisnlp algos/project/tomap-train.plan \
						 -alias fcu-mapping-file $MAPPINGFILE \
 						 -alias treeTaggerExecutable $TREETAGGER \
 						 -alias parFile $PARFILE \
 						 -alias yateaExecutable $YATEA \
						 -alias perlLib $PERLLIB \
						 -alias rcFile $RCFILE \
						 -alias configDir $CONFIGDIR \
						 -alias localeDir $LOCALEDIR  \
						 -alias fcu-candidates $CANDIDATEFILE \
						 -verbose;





elif [ $1 = "-annotate" ]
then
	# project terms on the corpus of bsv
	alvisnlp algos/main.plan -alias stylesheet-d2kab $STYLESHEET \
						 -alias stylesheet-vespa $STYLESHEET \
						 -alias stylesheet-alea $STYLESHEET \
						 -alias d2kab $D2KAB \
						 -alias vespa $VESPA \
						 -alias alea $ALEA \
						 -alias treeTaggerExecutable $TREETAGGER \
						 -alias parFile $PARFILE \
						 -alias fcu-source $FCU \
						 -alias fcu-mapping-file $MAPPINGFILE\
						 -alias stages-source $PPDO \
						 -alias stages-source-to-align $PPDO \
						 -alias yateaExecutable $YATEA \
						 -alias perlLib $PERLLIB \
						 -alias rcFile $RCFILE \
						 -alias configDir $CONFIGDIR  \
						 -alias localeDir $LOCALEDIR  \
						 -verbose \
						 -log ./output/logs/$(date +"%Y_%m_%d").log ;



elif [ $1 = "-stats" ]
then
	python algos/visualize/stats.py

fi


exit 0