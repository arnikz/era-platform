#
# Generates a weighted graph and adjacency matrix of collaborating countries
# using data from Platform DB (query result: country_in_network.xqy).
#

import os
import sys
import collections
import pandas as pd

infile = sys.argv[1]
graph_file = os.path.splitext(os.path.basename(infile))[0] + '.graph'
matrix_file = os.path.splitext(os.path.basename(infile))[0] + '.matrix'
networks = dict()

with open(infile, 'r') as fp:
    for ln in fp.readlines():
        country, network = ln.rstrip().split('|')
        if network in networks:
            networks[network].append(country)
        else:
            networks[network] = []
            networks[network].append(country)

country_pairs = collections.defaultdict(dict)
for (network, countries) in networks.items():
    #print(network, countries, len(countries))
    for i in range(0, len(countries)):
        for j in range(i+1, len(countries)):
            c1, c2 = countries[i], countries[j]
            if c1 in country_pairs and c2 in country_pairs[c1]:
                freq = country_pairs[c1][c2]
                country_pairs[c1][c2] = freq + 1
            else:
                country_pairs[c1][c2] = 1

del networks

with open(graph_file, 'w') as fp:
    for c1 in country_pairs.keys():
        for c2 in country_pairs[c1].keys():
            freq = country_pairs[c1][c2]
            fp.write("{0}\t{1}\t{2}\n".format(c1, c2, freq))

df = pd.DataFrame(country_pairs)
df.to_csv(matrix_file, sep='\t', float_format='%.0f')
