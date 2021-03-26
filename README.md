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
│   ├── project-rdf.plan
│   └── read-html.plan
├── output
│   ├── export.csv
│   └── words.txt
├── resources
│   ├── Corpus_test_d2kab_Viticulture.csv
│   ├── html2alvisnlp.xslt
│   ├── html_corpus
│   │   ├── 20190619_LOR_BSV_Viticulture_cle8c2fdf.html
│   │   ├── bsv_viti_mp_gaillac_n18_30072019_cle0fe8aa.html
│   │   └── bsv_viti_mp_gaillac_n18_30072019_cle0fe8aa.html__0__html.ttg
│   └── usageCulture20210112.rdf
└── visualize_results.ipynb
```
