for i in $(find ../resources/CorpusVespa.html/ -name '*.html'); do
  sed -i 's/\([[:alnum:]][[:space:]]*[^[:punct:]][[:space:]]*\)<\//\1.<\//g' "$i";
done
