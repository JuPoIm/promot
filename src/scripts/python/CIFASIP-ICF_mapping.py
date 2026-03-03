# python3.12.3
# utf-8
# Autrice : 0009-0000-5160-7927
# Author : 0009-0000-5160-7927
# GOAL : create a tsv file to be parsed by sssom-py into a sssom file from files with 2025 ICF and 2020 CIF-ASIP (2009 ICF data?) data
# BUT : créer un fichier tsv qui sera converti en sssom.tsv par sssom-py avec des données issues de la version 2025 d'ICF et des données issues de la version 2020 de CIF-ASIP (traduction de la version 2009 d'ICF ?)
# date de création : 23/09/2025??
# Creation date : 23/09/2025??
# date de version / Version date : 29/10/2025

import csv
import re
import pandas as pd
import sys

# get the shell date for mapping versioning
# récupération du premier argument de la commande shel (la date du shell) pour versionner le mapping
version = sys.argv[1]

# df creation
# création de la dataframe pour stocker les données ICF/CIF ASIP
columns = ['Foundation URI ICF', 'predicate_id', 'Code ICF', 'Label EN', 'URI data.esante','mapping_justification', 'author_id', 'mapping_date', 'confidence', 'comment']
df = pd.DataFrame(columns=columns)

# read file listing ICF URIs, labels and codes from https://icdcdn.who.int/static/releasefiles/2025-01/SimpleTabulation-ICF-fr.zip
# ouverture du fichier avec les URIs, labels et codes d'ICF téléchargé depuis le web browser avec le makefile du projet
with open('../data/imports/SimpleTabulation-ICF-fr.txt', newline='', encoding='utf-8') as tsvfile:
    reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
    for row in reader:
        if 'http://id.who.int/icd/entity/' not in row[0]: # if no Fundational URI pass / Si pas d'URI fondamentale on passe
            pass
        else:
            icf_uri = row[0]
            code = row[2]
            label_en = row[4]
            while '- ' in label_en :
                label_en = re.sub('- ', '', label_en)  # deletion of '- ' within labels / suppression des tirets devant les labels
            label_en = label_en.lower()
            # insert ICF data (URI, code, labels) in df / on ajoute les données dans la dataframe
            df.loc[len(df)]= {'Foundation URI ICF': icf_uri,
                              'predicate_id':'skos:exactMatch',
                              'Code ICF': code,
                              'Label EN': label_en,
                              'mapping_justification': 'semapv:LexicalMatching',
                              'author_id': "orcid:0009-0000-5160-7927",
                              'mapping_date': version,
                              'confidence': 1,
                              'comment': 'Matching uses icf codes (e.g. b7102) associated with subject_id and object_id to map the entities, if icf code is composed (e.g. b850-b869), matching uses english labels without code mention.'
                              }
            
# open file with CIF-ASIP data to link CIF-ASIP URIs to ICF URIs via ICF codes or labels
# ouverture du fichier avec le résultat de l'export robot depuis CIF-ASIP pour compléter la dataframe avec les labels en anglais ou les codes comme "clé"
with open ('../scripts/python/tmp/CIF-ASIP.tsv', encoding='utf-8') as tsvfile:
        reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
        for row in reader:
            # get data / on récupère les données de l'export robot
            asip_uri = row[0]
            icf_code = row[1]
            icf_label_en = row[2]
            # pass unrelevant line / on saute les lignes sans importance
            if asip_uri == 'IRI' or icf_code == '' or icf_label_en =='':
                pass
            else:
                if '-' in icf_code:
                    icf_label_en = re.sub(r' \([a-z][0-9]*-[a-z][0-9]*\)', '', icf_label_en)
                    # insert icf code via en label in df / on ajoute le code ICF via le label en anglais
                    df.loc[df['Label EN'] == icf_label_en, 'Code ICF'] = icf_code
                # insert CIF-ASIP URIs where ICF code is the same / on ajoute les URI fondamentales via le code ICF 
                df.loc[df['Code ICF'] == icf_code, 'URI data.esante'] = asip_uri

# delete now useless columns (that were used for mapping URIs)
# on supprime les colonnes qui nous ont servies de porte d'entrée pour lier les URIs ICF et CIF
df = df.drop(columns=['Code ICF', 'Label EN'])
# rename columns for suiting sssom
# on renome les colonnes pour préparer le tsv
df.rename(columns={'Foundation URI ICF': 'subject_id','URI data.esante': 'object_id'}, inplace=True)
# delete incomplete columns (due to diff between used-by-CIF-ASIP 2009 (? the one used by UMLS) ICF version and the 2025 ICF version)
# i dont know for subject_id
# on supprime les lignes où il manque des données
df = df.dropna(subset=["subject_id"])
sssom_df = df.dropna(subset=["object_id"])
# just a little check
#print(sssom_df)
# create tsv file for sssom parsing
# on crée le tsv qui sera converti par la commande sssom-py en un fichier SSSOM
sssom_df.to_csv('../scripts/python/tmp/icf-to-cifasip_all.tsv', sep='\t', index=False)


# create tsv file for sssom parsing with only mapping for iri in whofic_import
# on crée le tsv qui sera converti par la commande sssom-py en un fichier SSSOM pour seulement les mappings des iri présents dans whofic_import
promot_df = pd.DataFrame(columns=sssom_df.columns)

with open ('../scripts/python/tmp/icf_import_iri.tsv', encoding='utf-8') as tsvfile:
    reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
    for row in reader:
        iri = row[0]
        data = sssom_df[sssom_df['subject_id'] == iri]
        promot_df = pd.concat([promot_df, data], ignore_index = True)

promot_df.to_csv('../scripts/python/tmp/icf-to-cifasip_promot.tsv', sep='\t', index=False)
promot_cif_list_df = promot_df.filter("object_id")
promot_cif_list_df = promot_cif_list_df.rename(columns={"object_id" : "#object_id"})
promot_cif_list_df.to_csv('../ontology/imports/cif_terms.txt', sep='\t', index=False)

# txt = open('../ontology/imports/cifasip_terms.txt', "w+", encoding='utf-8')
# for index, row in promot_df.iterrows():
#     txt.write(f"{row['object_id']}\n")
# txt.close()