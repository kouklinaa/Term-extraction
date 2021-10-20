#!/bin/bash


# corpus
D2KAB=resources/corpus/d2kab/
VESPA=resources/corpus/vespa/
ALEA=resources/corpus/alea/

# html segmentation 
STYLESHEET=resources/alvisnlp/segmentation/html2alvisnlp.xslt


# -------------------change the version of FCU and PPDO if needed -----------------------

# referentiels
FCU=frenchCropUsage_20210525
PPDO=ppdo_20210726
FCU_REFERENTIEL=resources/referentiels/$FCU.rdf
PPDO_REFERENTIEL=resources/referentiels/$PPDO.rdf

# tomap files
FCU_MAPPINGFILE=resources/alvisnlp/tomap/$FCU.txt
FCU_CANDIDATEFILE=resources/alvisnlp/tomap/$FCU.tomap
PPDO_MAPPINGFILE=resources/alvisnlp/tomap/$PPDO.txt
PPDO_CANDIDATEFILE=resources/alvisnlp/tomap/$PPDO.tomap


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

find . -name ".DS_Store" -delete;

if [ -z "$1" ]
then
	echo ""
	echo "No argument provided."
	echo "Please, choose an option :"
	echo "	-tomap-train"
	echo "	-annotate"
	echo "	-stats"
	echo ""



elif [ $1 = "-tomap-train" ]
then 

	# # create a mapping file (list of candidates for tomap-train)
	# python algos/export/rdf2tabular.py $FCU > $MAPPINGFILE;


	# calculate syntaxic heads for the candidates from the mapping file
	alvisnlp algos/project/tomap-train.plan \
						 -alias mapping-file $FCU_MAPPINGFILE \
 						 -alias treeTaggerExecutable $TREETAGGER \
 						 -alias parFile $PARFILE \
 						 -alias yateaExecutable $YATEA \
						 -alias perlLib $PERLLIB \
						 -alias rcFile $RCFILE \
						 -alias configDir $CONFIGDIR \
						 -alias localeDir $LOCALEDIR  \
						 -alias candidates $FCU_CANDIDATEFILE \
						 -verbose;

	# calculate syntaxic heads for the candidates from the mapping file
	alvisnlp algos/project/tomap-train.plan \
						 -alias mapping-file $PPDO_MAPPINGFILE \
 						 -alias treeTaggerExecutable $TREETAGGER \
 						 -alias parFile $PARFILE \
 						 -alias yateaExecutable $YATEA \
						 -alias perlLib $PERLLIB \
						 -alias rcFile $RCFILE \
						 -alias configDir $CONFIGDIR \
						 -alias localeDir $LOCALEDIR  \
						 -alias candidates $PPDO_CANDIDATEFILE \
						 -verbose;





elif [ $1 = "-annotate" ]
then
	# project terms on the corpus of bsv
	alvisnlp  algos/main.plan -alias stylesheet-d2kab $STYLESHEET \
						 -alias stylesheet-vespa $STYLESHEET \
						 -alias stylesheet-alea $STYLESHEET \
						 -alias d2kab $D2KAB \
						 -alias vespa $VESPA \
						 -alias alea $ALEA \
						 -alias fcu-source $FCU_REFERENTIEL \
						 -alias fcu-mapping-file $FCU_MAPPINGFILE \
						 -alias stages-source $PPDO_REFERENTIEL \
						 -alias stages-source-to-align $PPDO_REFERENTIEL \
						 -alias stages-mapping-file $PPDO_MAPPINGFILE \
						 -alias treeTaggerExecutable $TREETAGGER \
						 -alias parFile $PARFILE \
						 -alias yateaExecutable $YATEA \
						 -alias yateaExecutable-stages $YATEA \
						 -alias perlLib $PERLLIB \
						 -alias perlLib-stages $PERLLIB \
						 -alias rcFile $RCFILE \
						 -alias rcFile-stages $RCFILE \
						 -alias configDir $CONFIGDIR  \
						 -alias configDir-stages $CONFIGDIR  \
						 -alias localeDir $LOCALEDIR  \
						 -alias localeDir-stages $LOCALEDIR  \
						 -verbose \
						 -log ./output/logs/$(date +"%Y_%m_%d").log ;



elif [ $1 = "-stats" ]
then
	python algos/visualize/stats.py

fi


exit 0