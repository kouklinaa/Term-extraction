# Documentation


## 1.	"BSV"
	
	This column specifies a full path of Plant Health Bulletins (BSV). The bulletins must be in html format and should contain conjunctions - enumerations of nominal groups or noun phrases in a text. 

## 2.	"Corpus"

	This conlumn specifies the names of corpora, containing BSV:

		-> test D2KAb is a corpus of 230 bulletins on vineyards, vegetable gardening (tomato, lettuce, carrot) and field crops, set up within the D2KAB project. This test corpus is manually indexed to check the quality of of the TALN processes implemented during the d2kab project.

		-> test VESPA is a subset of the vespa corpus composed of 500 BSV whose indexes were built manually. This test corpus was used to check the quality of the automatic indexing process used to index the whole vespa corpus.

		-> test ALEA is a subset of 150 ballots randomly drawn from the from the automatically collected ballots. This test corpus is used to perform a second series of tests of the indexing processes of the indexing processes of the d2kab project

## 3.	"Location"

	This column shows the interval of characters which hold the conjunction within an html version of the BSV.

## 4.	"Context before"

	This column shows 20 characters before the extracted conjunction.

## 5.	"Extracted conjunction"

	This column shows the extracted conjunction (enumeration of nominal groups in a text). In our case, a conjunction holds concepts that arready exist in the thesaurus French Crop Usage (FCU), and concepts that are missing from it. The conjunction is extracted with the aim to enrich the thesaurus, by proposing new concepts (named hereafter as proposals).

## 6.	"Context after"

	This column shows 20 characters after the extracted conjunction.

## 7.	"Matches with FCU"

	This column specifies concepts that arready exist in the thesaurus French Crop Usage (FCU).

## 8.	"Proposal"

	This column specifies a proposal of a new concept/label for the thesaurus French Crop Usage (FCU).


## 9.	"Possible references"

	This column specifies the skos:broader values of the concepts matched with FCU . They can be used as possible references for the new concepts/labels.


## 10.	"Grammatically pertinent" :

	This column asks if the proposal is a well-formed term? It allows them to trace back errors in NG detection.

	Possible answers :
		-> no, yes


## 11.	"Within FCU" :

	This column asks if the proposal is within the scope of FCU? Regardless of whether the proposal is a novelty or not. This helps to eliminate off-topic proposals. 

	Possible answers :
		-> no, yes


## 12.	"Absent from FCU" :

	This column asks if the proposal is missing from FCU? If it is something new that enriches FCU? 

	Possible answers :
		-> no, new concept, new label


## 13.	"Relevance of reference" :

	This column asks if the suggested reference is accurate? The question is intended to assess the quality of the mapping.

	Possible answers :
		-> no, yes


## 14. "Other comments" :

	This column gives a possibility to leave any other remarks regarding the extraction. 
