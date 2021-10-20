#!/bin/env python3

import owlready2 as owl
import sys


fcu_onto = owl.get_ontology(sys.argv[1]).load()
for i in fcu_onto.individuals():
    prefs = i.prefLabel
    if len(prefs) == 0:
        sys.stderr.write('no prefLabel, ignoring %s\n' % i.iri)
        continue
    pref = prefs[0]
    print('%s\t%s\t%s' % (pref, i.iri, pref))
    for alt in i.altLabel:
        print('%s\t%s\t%s' % (alt, i.iri, pref))