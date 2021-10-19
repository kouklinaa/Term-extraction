#!/bin/env python3


# packages
import pandas as pd
import numpy as np
import os
import plotly.graph_objects as go
import plotly.express as px
from sklearn.decomposition import PCA

def create_df(path_to_file):
	df = pd.read_csv(path_to_file, delimiter="\t", encoding='utf-8') 
	return df




def count_bsv(df):
	grouped_df = df[[ 'corpus','bsv','prefLabel']].groupby(['corpus', 'bsv', 'prefLabel'])['prefLabel'] \
							 .count() \
							 .reset_index(name='count') \
							 .sort_values(['prefLabel'], ascending=True) # group by prefLabel
	
	print("\nBSV which have at least one concept :\n")
	print(grouped_df[["bsv", "corpus"]].groupby("corpus").describe() )# group by culture
	return grouped_df




def visualize_bsv(df, approach):
	if approach == "baseline":
		fig = px.sunburst(df,
				  path=[ 'corpus','prefLabel'], 
				  values='count')

		fig.update_layout(
			showlegend=False,
			font_size=25,
			width=1000, height=1000,
			autosize=False)

		fig.write_html("output/visualisations/corpus-baseline.html")

	if approach == "tomap":
		fig = px.sunburst(df,
				  path=[ 'corpus','prefLabel'], 
				  values='count')

		fig.update_layout(
			showlegend=False,
			font_size=25,
			width=1000, height=1000,
			autosize=False)

		fig.write_html("output/visualisations/corpus-tomap.html")

	return True

def load_features(filepath):
	'''
	INPUT :
	OUTPUT :
	'''
	# read csv file
	df = pd.read_csv(filepath, sep = '\t', encoding = 'utf8', names = ['bsv', 'prefLabel', 'score'])
	grouped = df.groupby("bsv")

	'''
	for name,group in grouped:
		print(name)
		print(group)
	'''

	# transpose df to a tf-idf matrix
	features = df.pivot(index='prefLabel', columns='bsv', values='score')
	# replace NaN to null
	features = features.fillna(0)

	return features




def pca_var_ratio(df):

	'''
	INPUT :
	OUTPUT :
	'''

	pca = PCA()
	pca.fit(df)
	exp_var_cumul = np.cumsum(pca.explained_variance_ratio_)

	fig = px.area(
		x=range(1, exp_var_cumul.shape[0] + 1),
		y=exp_var_cumul,
		labels={"x": "# Components", "y": "Explained Variance"}
		)
	fig.show()
	return True


def show_pca_components(df, num, approach):

	if approach == "baseline":
		pca = PCA(n_components=num)
		components = pca.fit_transform(df)
		fig = px.scatter(components, x=0, y=1, color = df.index )
		fig.write_html("output/visualisations/bm25-baseline.html")

	if approach == "tomap":
		pca = PCA(n_components=num)
		components = pca.fit_transform(df)
		fig = px.scatter(components, x=0, y=1, color = df.index )
		fig.write_html("output/visualisations/bm25-tomap.html")

	return True
