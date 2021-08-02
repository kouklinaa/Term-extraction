# README


<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about">About</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#execution">Execution</a></li>
      </ul>
    </li>
    <li><a href="#algorithm">Algorithm</a></li>
  </ol>
</details>


## About

The global purpose of the project is to :
* Create semantic annotations of Plant Health Bulletins
* Enhance terminology coverage of semantic resources
* Modelize the results with a Web Annotation Data Model (W3C)


The bulletins have been transformed from their initial format (pdf) into a textual format (html) in order to facilitate their textual preprocessing. They have also been divided into different corpora by : types of mentioned crops (vines, legumes, etc.), method of their selection (manual or random).


## Getting Started

The semantic annotation is made by AlvisNLP engine (*Bibliome*). It consists in projecting the terminological part of semantic resources onto the textual version of the bulletins.

### Prerequisites

In order to use the semantic annotation plans, you will need to install the following tools :
* AlvisNLP engine
* TreeTagger (+ French.par)
* YaTeA

### Execution

* Run this command :
  ```sh
  $ alvisnlp  main.plan
  ```
* Or :
  ```sh
  $ alvisnlp  main.plan -browser
  ```

## Algorithm

* **I. Loading corpora**

  The html versions of bulletins are passed to *XMLReader* module. It transforms them into AlvisNLP documents which store not only the textual output of the bulletin but also the corresponding html tags.


* **II. Preprocessing**
  * The documents are later segmented into sentences and tokenized with the segmentation plan of AlvisNLP :

  ```xml
  <import>res://segmentation.plan</import>
  ```

  * Then, the lemmatization part begins. Once TreeTagger has processed the corpus, it adds the predicted POS tag and lemma to the respective posFeature and lemmaFeature features of the corresponding annotations.
  ```xml
  <!-- NB: it is necessary to indicate the path
  to the TreeTagger executable and
  the French parameter file : -->
  <tt class="TreeTagger">
    <parFile>.../tree-tagger/lib/french.par</parFile>
    <treeTaggerExecutable>.../tree-tagger/bin/tree-tagger</treeTaggerExecutable>
    <noUnknownLemma/>
    <inputCharset>UTF-8</inputCharset>
    <outputCharset>UTF-8</outputCharset>
  </tt>
  ```


* **III. Annotation :**

  * Plants
    * The first method to map plant concepts is by using the *RDFProjector* module. It takes on the *French Crop Usage* thesaurus and associates skos labels of concepts with named entities in bulletins:

    ```xml
    <project-baseline class="RDFProjector">
      <source>resources/fcu/frenchCropUsage_20210525.rdf</source>
      <targetLayerName>fcu-baseline</targetLayerName>
      <subject layer="words" feature="lemma"/>
      <language>fr</language>
      <uriFeatureName>uri</uriFeatureName>
      <resourceTypeURIs>owl:NamedIndividual</resourceTypeURIs>
      <wordStartCaseInsensitive/>
      <constantAnnotationFeatures>type=RDFProjector</constantAnnotationFeatures>
    </project-baseline>
    ```
    * The second method is called *ToMap*. It aims to classify named entities by comparing the syntactic structure between the entities and skos labels. During the classification, a jaccard similarity is calculated. This score helps to choose the mappings we want to keep :
    ```xml
      <classify class="TomapProjector">
        <subject layer="words" feature="lemma"/>
        <yateaFile output-feed="true">../yatea.xml</yateaFile>
        <tomapClassifier graylist="resources/alvisnlp/tomap/tomap-graylist.txt" >resources/alvis/tomap/frenchCropUsage_20210525.tomap</tomapClassifier>
        <targetLayerName>fcu-tomap</targetLayerName>
        <conceptFeature>IRI</conceptFeature>
        <explanationFeaturePrefix>tomap-</explanationFeaturePrefix>
        <scoreFeature>similarity</scoreFeature>
        <lemmaKeys/>
      </classify>
      ```

  * Phenological stages
    * *RDFProjector* module can be used as well for mapping phenological stages. The only difference is the semantic resource that serves as an entry. Here it's the *BBCH based Plant Phenological Description Ontology* :

    ```xml
    <project-stages class="RDFProjector">
      <source>resources/ppdo/ppdo_20210726.rdf</source>
      <targetLayerName>stages</targetLayerName>
      <subject layer="words" feature="lemma"/>
      <language>fr</language>
      <uriFeatureName>uri</uriFeatureName>
      <resourceTypeURIs>owl:NamedIndividual</resourceTypeURIs>
      <wordStartCaseInsensitive/>
      <constantAnnotationFeatures>type=RDFProjector</constantAnnotationFeatures>
    </project-stages>
    ```

    * In addition to that, syntactic patterns can be created. As many phenological stages are written in codes and have typographical variations in bulletins, regular grammars are very useful. So, with help of the *PatternMatcher* module, targeting tokens, various forms of BBCH codes have been extracted. Later, they are normalised to their canonical form and mapped with the corresponding skos label:

    ```xml
    <!-- BBCH-00 -->
    <BBCH_DD class="PatternMatcher">
      <pattern>
        [ @form =^ "BBCH" ]
        [ @form == "-"]?
        (number:[ @form =~ "[0-9]{2}$" ])
      </pattern>
      <actions>
        <createAnnotation layer="bbch" features='canonical-form=("BBCH " ^ group:number)'/>
      </actions>
      <constantAnnotationFeatures>type=BBCH-DD</constantAnnotationFeatures>
    </BBCH_DD>
    ```


  * Themes
    * One of the last types of annotations focuses on thematical segmentation. It is relevant as it helps to differentiate some ambigous concepts (such as "champignons", "pois", etc.) and pass them if they are found in parts which do not satisfy the criterea. For that matter, the whole bulletin should get annotated thematically. Here's a small example of a pattern :

    ```xml
    <edition class="PatternMatcher">
      <layerName>html</layerName>
      <pattern>
        [@tag ^= "H"  and @tag =~ "[0-9]" and @form ^= "N°"]
        [ true ]{0,5}
        [@tag ^= "H"  and @tag =~ "[0-9]" and @form =~ "[0-9]"]
      </pattern>
      <actions>
        <createAnnotation layer="themes"/>
      </actions>
      <constantAnnotationFeatures>type=EDITION</constantAnnotationFeatures>
      <overlappingBehaviour>ignore</overlappingBehaviour>
    </edition>
    ```
    First, we target the html tags being stored in *html* layer. Then, we select the tags with the *PatternMatcher* module. The first entity should contain  "N°" in its initial form and has to be stored in a title. This entity can be followed by maximum 5 html tags. The last one has to be also stored in a title but it should contain information about the date of the publication (in digits). The annotation is later stored in a layer named *themes* and is typed as *EDITION*.
    Similar patterns were created to extract table of contents, subscription, weather and financial segments. Others like risk and phenological stages have demanded prior mappings with lists of bioagressors and deseases.
