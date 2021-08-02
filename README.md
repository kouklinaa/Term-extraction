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

The global purpose of this project is to :
* Create semantic annotations of Plant Health Bulletins
* Enhance terminology coverage of agricultural resources
* Modelize the results with Web Annotation Data Model (W3C)


The bulletins are transformed from their initial format (pdf) into a textual format (html) in order to facilitate their textual preprocessing. They are also divided into different corpora by : types of mentioned crops (vines, legumes, etc.), method of their selection (manual or random).


## Getting Started

The semantic annotation is made by the AlvisNLP engine (*Bibliome*). It consists in projecting the terminological part of semantic resources onto the textual version of the bulletins.

### Prerequisites

In order to use the annotation plans, you will need to install the following tools :
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

The main script consists of three parts :

* **I. Loading corpora**

  The html versions of bulletins are passed to *XMLReader* module. It transforms them into AlvisNLP documents which store not only the textual output of the bulletin but also the corresponding html tags.


* **II. Preprocessing**
  * The documents are later segmented into sentences and tokenized with the standard segmentation plan of AlvisNLP :

  ```xml
  <import>res://segmentation.plan</import>
  ```

  * Then, the lemmatization step begins. Once TreeTagger has processed the corpus, it adds the predicted POS tag and lemma to the respective posFeature and lemmaFeature features of the corresponding annotations.
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
    * The first method implements *RDFProjector* module. It takes on the *French Crop Usage* thesaurus and associates its skos labels with named entities :

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
    * The second method is called *ToMap*. It aims to classify named entities by comparing the syntactic structures of entities and of skos labels. During the classification, a jaccard similarity is calculated between the terms. This lets us choose associations to keep :
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
    * *RDFProjector* module is used again. The only difference is the semantic resource. Here it's the *PPDO* knowledge base :

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

    * *PatternMatcher*

  * Bioagressors
    * *TabularProjector*

  * Conjunctions
    * *PatternMatcher*

  * Deseases
    * *PatternMatcher*

  * Themes
    * *PatternMatcher*
