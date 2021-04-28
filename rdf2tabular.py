#!/bin/env python3

import owlready2 as owl
import sys


onto = owl.get_ontology(sys.argv[1]).load()
for i in onto.individuals():
    for lbl in i.prefLabel:
        print('%s\t%s' % (lbl, i.iri))
    for lbl in i.altLabel:
        print('%s\t%s' % (lbl, i.iri))
