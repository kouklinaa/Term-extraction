import os
import pandas as pd
import numpy as np
import re, operator
from operator import itemgetter
from itertools import islice

# stats

from scipy import stats
from scipy import special
from scipy.spatial.distance import cosine
from scipy.stats import zipf
from sklearn.decomposition import PCA

# dataviz
import matplotlib.pyplot as plt
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots



def read_fcu(filename, corpus_name):

    '''
    INPUT :
    OUTPUT :
    '''


    # description du corpus
    print("========> Counting bsv..")
    total = 0
    for root, dirs, files in os.walk(corpus_name):
        total += len(files)
    print("\nTotal : {} bsv dans le corpus".format(total))


    # create df
    print("\n========> Creating a dataframe..")
    df = pd.read_csv(filename, delimiter="\t", encoding='utf-8')


    # short descriptions
    print("\n========> Making short descriptions..")
    print("\nPrefLabel :\n")
    print(df['prefLabel'].describe())
    print("\n\nBSV :\n")
    print(df['bsv'].describe())
    #print("\n\nLength :\n")
    #print(df['length'].describe())

    # save dictionary of extracted labels
    label_counter = df['prefLabel'].value_counts()
    label_dict = label_counter.to_dict()
    df_freq = pd.DataFrame.from_dict(label_dict,orient='index', columns=['count'])
    #df_freq.reset_index(level='prefLabel')
    df_freq = df_freq.reset_index().rename({'index':'prefLabel'}, axis = 'columns')
    #df_freq['prefLabel'] = df_freq.index
    print("\nTop 10 labels :\n{}".format(df_freq[:10]))




    return df, df_freq



def show_frequencies(df_freq):

    '''
    INPUT :
    OUTPUT :
    '''

    # show scatter graph
    fig = px.scatter(df_freq, x=df_freq['prefLabel'], y=df_freq['count'])
    fig.show()

    # show tree graph
    fig = px.treemap(df_freq, path=df_freq , values='count')
    fig.show()

    return True




def show_differences(df1, df2):

    '''
    INPUT :
    OUTPUT :
    '''

    print(df1['prefLabel'].isin(df2['prefLabel']).value_counts())
    print(df1[~df1['prefLabel'].isin(df2['prefLabel'])])

    return True



def scatter_matrix(df, list_of_dimensions):

    '''
    Scatter plots show how much one variable is affected by another or the relationship between them with the help of dots in two dimensions.
    Scatter plots are very much like line graphs in the concept that they use horizontal and vertical axes to plot data points

    INPUT :
    OUTPUT :
    '''

    fig = px.scatter_matrix(df,
    dimensions=list_of_dimensions,
    color=df.index,
    title="Scatter matrix",
    labels={col:col.replace('_', ' ') for col in df.columns}) # remove underscore
    fig.update_traces(diagonal_visible=True)
    fig.show()
    return True



def cosine_similarity(col1, col2):
    '''
    The cosine measure similarity is a similarity metric that depends on envisioning user preferences as points in space.
    The cosine of a small angle is near 1, and the cosine of a large angle near 180 degrees is close to –1.
    This is good, because small angles should map to high similarity, near 1, and large angles should map to near –1

    INPUT :
    OUTPUT :
    '''

    result = (1 - cosine(col1, col2))
    print(result)
    return result


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


def show_pca_components(df, num):

    pca = PCA(n_components=num)
    components = pca.fit_transform(df)
    fig = px.scatter(components, x=0, y=1, color = df.index )
    fig.show()

    return True
