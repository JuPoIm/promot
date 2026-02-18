# python3.12.3
# utf-8
# Autrice / Author : juliette.potier@institutimagine.org
# GOAL : create a template ROBOT with spanish and french labels for ICF classes
# BUT : créer un template avec les labels espagnols et français pour les classes ICF
# date de création / Creation date : 23/09/2025
# date de version / Version date : 23/10/2025

import csv
import re
import pandas as pd

# df creation
# création de la dataframe au format template ROBOT
columns = ['ID', 'Label EN', 'Label FR', 'Label ES', 'Comment', 'CrossRef']
df = pd.DataFrame(columns=columns)

# Read file with 2025 Fundational URI and french translated labels from https://icdcdn.who.int/static/releasefiles/2025-01/SimpleTabulation-ICF-fr.zip
with open('../data/imports/SimpleTabulation-ICF-fr.txt', newline='', encoding='utf-8') as tsvfile:
    reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
    for row in reader:
        if 'http://id.who.int/icd/entity/' not in row[0]: # if no Fundational URI pass
            pass
        else:
            icf_uri = row[0]
            label_fr = row[5]
            while '- ' in label_fr :
                label_fr = re.sub('- ', '', label_fr)  # suppression des '- ' dans les labels
            df.loc[len(df)]=  {'ID': icf_uri,
            'Label FR': label_fr,
            'Comment': 'Source for French and Spanish labels: https://icd.who.int/browse/2025-01/icf/ > Info > Spreadsheet files (on French and Spanish browser version)'}

# Read file with 2025 Fundational URI and spanish translated labels from https://icdcdn.who.int/static/releasefiles/2025-01/SimpleTabulation-ICF-es.zip
with open('../data/imports/SimpleTabulation-ICF-es.txt', newline='', encoding='utf-8') as tsvfile:
    reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
    for row in reader:
        if 'http://id.who.int/icd/entity/' not in row[0] : # if no Fundational URI pass
            pass
        else:
            icf_uri = row[0]
            label_en = row[4]
            while '- ' in label_en :
                label_en = re.sub('- ', '', label_en)  # suppression des '- ' dans les labels 
            label_es = row[5]
            while '- ' in label_es :
                label_es = re.sub('- ', '', label_es)  # suppression des '- ' dans les labels 
            df.loc[df['ID'] == icf_uri, 'Label ES'] = label_es
            df.loc[df['ID'] == icf_uri, 'Label EN'] = label_en

template_df = pd.DataFrame(columns=columns)
template_df.loc[0]= {'ID': 'ID',
            'Label EN': 'AL rdfs:label@en',
            'Label FR': 'AL rdfs:label@fr',	
            'Label ES' : 'AL rdfs:label@es',
            'Comment': 'A rdfs:comment',
            'CrossRef': 'A oboInOwl:hasDbXref SPLIT=|'
            }


with open ('../scripts/python/tmp/icf_import_iri.tsv', encoding='utf-8') as tsvfile:
    reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
    for row in reader:
        iri = row[0]
        data = df[df['ID'] == iri]
        template_df = pd.concat([template_df, data], ignore_index = True)

# with open ('../scripts/python/tmp/icf-to-cifasip_promot.tsv', encoding='utf-8') as xref_file:
#     reader = csv.reader(xref_file, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
#     for row in reader:
#         iri = row[0]
#         xref = row[2]
#         template_df.loc[template_df['ID'] == iri, 'CrossRef'] = xref

template_df.to_csv('../templates/icf_labels_es-fr.tsv', sep='\t', index=False)