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

This project aims to :
* Create semantic annotations of Plant Health Bulletins
* Enhance terminology coverage of agricultural resources
* Modelize the results with Web Annotation Data Model (W3C)


The bulletins are transformed from their initial format (pdf) into a textual format (html) in order to facilitate their textual preprocessing. They are also divided into different corpora by : types of mentioned crops (vines, legumes, etc.), method of their selection (manual or random).

The semantic annotation is made by the AlvisNLP engine (*Bibliome*). It consists in projecting the terminological part of semantic resources onto the textual version of the bulletins.

## Getting Started

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


* **Load corpora**

  The html versions of bulletins are passed to *XMLReader* module. It transforms them into AlvisNLP documents which store not only the textual output of the bulletin but also the corresponding html tags.


* **II. Preprocess**
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


* **III. Create annotations :**

  * Plants
    * *RDFProjector*
    * *ToMap*

  * Phenological stages
    * *RDFProjector*
    * *PatternMatcher*

  * Bioagressors
    * *TabularProjector*

  * Conjunctions
    * *PatternMatcher*

  * Deseases
    * *PatternMatcher*

  * Themes
    * *PatternMatcher*
