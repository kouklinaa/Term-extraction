#!/bin/env python3


from utils import *



print("\n\nBASELINE")

# concepts
baseline = create_df("output/annotations/fcu-baseline-annotations.csv") 
baseline_bsv = count_bsv(baseline)
visualize_bsv(baseline_bsv, "baseline")


# scores
bm25_baseline = load_features("output/annotations/fcu-baseline-bm25.csv")
# drop nan index
bm25_baseline = bm25_baseline.reset_index().dropna().set_index('prefLabel')
# get an explained variance ratio
pca_var_ratio(bm25_baseline)
# show components
show_pca_components(bm25_baseline, num = 40, approach = "baseline")






print("\n\nTOMAP")

# concepts
tomap = create_df("output/annotations/fcu-tomap-annotations.csv") 
tomap_bsv = count_bsv(tomap)
visualize_bsv(tomap_bsv, "tomap")


# scores
bm25_tomap = load_features("output/annotations/fcu-tomap-bm25.csv")
# drop nan index
bm25_tomap = bm25_tomap.reset_index().dropna().set_index('prefLabel')
# get an explained variance ratio
pca_var_ratio(bm25_tomap)
# show components
show_pca_components(bm25_tomap, num = 40, approach = "tomap")

