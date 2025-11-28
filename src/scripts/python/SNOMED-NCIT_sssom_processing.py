# python3.12.3
# utf-8
#--EN------------------------------- #--FR-------------------------------------
# Author : 0009-0000-5160-7927       # Autrice : 0009-0000-5160-7927 
# GOAL : process mappings.sssom.tsv  # BUT : Aléger le mapping fournis par Charile H
# from Charlie Hoylt to lighten it   # oylt pour ne récupérer que les mappings entre snomed et ncit
# by extracting only snomedct/ncit   #
# mappings
# date de version / Version date : 21/11/2025

# import csv

# # read file listing ICF URIs, labels and codes from https://icdcdn.who.int/static/releasefiles/2025-01/SimpleTabulation-ICF-fr.zip
# # ouverture du fichier avec les URIs, labels et codes d'ICF téléchargé depuis le web browser avec le makefile du projet
# with open('../data/mappings.sssom.tsv', newline='', encoding='utf-8') as input_file:
#     reader = csv.reader(input_file, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
#     with open('../data/mappings-light.sssom.tsv', 'w', newline='', encoding='utf-8') as output_file:
#         writer = csv.writer(output_file, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
#         for row in reader:
#             subject_id = row[0]
#             predicate_id = row[3]
#             if subject_id == "subject_id":
#                 writer.writerow(row)
#             if 'ncit' in subject_id or 'snomed' in subject_id:
#                 writer.writerow(row)

#

import pandas as pd
# Lire le fichier JSON
df = pd.read_json('../scripts/python/tmp/resultats_p-01.json')
# Convertir en CSV
df.to_csv('../scripts/python/tmp/output.csv', index=False)