## How-to

Download html pages into the given repository 
```
bash download_corpus.sh path/to/file/*.csv
```

Match terms within an html page
```
alvisnlp -browser main.plan
```

## Repository tree :
```
├── README.md
├── download_corpus.sh
├── main.plan
├── modules
│   ├── export.plan
│   ├── project-rdf.plan
│   └── read-html.plan
├── output
│   └── export.txt
└── resources
    ├── Corpus_test_d2kab_Viticulture.csv
    ├── html2alvisnlp.xslt
    ├── html_corpus
    │   ├── 20190619_LOR_BSV_Viticulture_cle8c2fdf.html
    │   ├── 20190710_LOR_BSV_Viticulture_cle8bd128.html
    │   ├── 20190731_LOR_Viticulture-1_cle45ef1d.html
    │   └── *.html
    └── usageCulture20210112.rdf
```
