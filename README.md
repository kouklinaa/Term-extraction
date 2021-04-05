## How-to

Download html pages from links stored in the file *`Corpus_test_d2kab_Viticulture.csv`*
```
$ bash download_corpus.sh 
```

Match terms with AlvisNLP tool
```
$ alvisnlp -browser main.plan
```

Visualize the most frequent terms
```
$ jupyter notebook visualize_results.ipynb
```

## Repository tree :
```
├── README.md
├── download_corpus.sh
├── main.plan
├── modules
│   ├── execute-treetagger.plan
│   ├── export.plan
│   ├── project-lemma.plan
│   └── read-html.plan
├── output
│   ├── export.csv
│   ├── export_without_quotes.csv
│   ├── language_tool.csv
│   ├── language_tool.txt
│   ├── tfidf.txt
│   └── words.txt
├── resources
│   ├── CorpusTestD2kabViti.html
│   │   ├── 20190619_LOR_BSV_Viticulture_cle8c2fdf.html
│   │   ├── ...
│   ├── Corpus_test_d2kab_Viticulture.csv
│   ├── catalog-v001.xml
│   ├── grapevine_grapevine_scales.owl
│   ├── html2alvisnlp.xslt
│   ├── ppdo.rdf
│   ├── stades.rdf
│   └── usageCulture20210112.rdf
└── visualize_results.ipynb
```
