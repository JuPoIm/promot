# python3.12.3
# utf-8
# Autrice / Author : juliette.potier@institutimagine.org
# GOAL : script to create the template ROBOT with the relations files in /data/promot/*.tsv
# BUT : créer le template ROBOT avec les fichiers /data/promot/*.tsv
# date de création / Creation date : 22/12/2025
# date de version / Version date : 24/02/2026

import csv
import pandas as pd
import os


# import des templates ROBOT existants en deux dataframe pandas pour la base et les traductions ICF
print ('Imports ROBOT templates base and ROBOT template with icf translations')
print ('Convertion en deux dataframes')
component_df = pd.read_csv("../templates/promot-component-base.tsv", sep="\t")
translation_df = pd.read_csv("../templates/icf_labels_es-fr.tsv", sep="\t")

# axioms_df creation with ROBOT template format 
# création de la dataframe des axioms au format template
print ('Creation axioms dataframe')
axioms_df = pd.DataFrame(columns = ['ID', 'Label EN', 'Annotation', 'Type', 'Parent Class'])
axioms_df.loc[0] = {'ID': 'ID', 'Label EN': 'AL rdfs:label@en', 'Annotation' : 'A PROMOT:1000001 SPLIT=|', 'Type': 'TYPE', 'Parent Class': 'SC % SPLIT=|'}

# creation of the dictionnary IRI : Parent class expression
# création des dictionnaires IRI : Parent class
dico_axioms = {}
dico_annotations = {}
# creation of the lists of property IRIs
# création des listes avec les IRI des properties
list_objectprop = []
list_annotationprop = []


# Get all files in /src/data/promot/
# récupère la liste des fichiers dans /src/data/promot/
files = os.listdir("../data/promot/")

for f in files:
    print (f'Ouverture de {f}')
    print (f'Openning of {f}')
    # Read csv file with relations and fill dictionnary with relations
    with open(f"../data/promot/{f}", newline='', encoding='utf-8') as tsvfile:
        reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
        #print ('ouverture fichier')
        for row in reader:
            subject_class = ''
            subject_label = ''
            predicate = ''
            object_class = ''
            #print ('-- lecture ligne')
            if row[0] == 'Subject_iri': # pass the first line
                pass
            elif row[2] == 'PROMOT:1000001': # s'il s'agit d'une annotation property | if it is the PROMOT annotation property
                subject_class = row[0]
                subject_label = row[1]
                predicate = row[2]
                data = row[6]
                if predicate in list_annotationprop : # si l'annotation property a déjà été rencontrée | if the annotation property is already known
                    pass
                else :
                    list_annotationprop.append(predicate)
                if subject_class in dico_annotations.keys(): # if there already is a relation using the class as a subject
                    dico_annotations[subject_class][0] = f'{dico_annotations[subject_class][0]}|{data}'
                else: # if no relation using the class as a subject already exists
                    list = [f'{data}', subject_label]
                    dico_annotations[subject_class] = list
            else: # add the relation to the template-to-be column
                subject_class = row[0]
                subject_label = row[1]
                predicate = row[2]
                expression = row[4]
                object_class = row[5]
                if predicate in list_objectprop :
                    pass
                else :
                    list_objectprop.append(predicate)
                if subject_class in dico_axioms.keys(): # if there already is a relation using the class as a subject
                    dico_axioms[subject_class][0] = f'{dico_axioms[subject_class][0]}|({predicate} {expression} {object_class})'
                else: # if no relation using the class as a subject already exists
                    list = [f'({predicate} {expression} {object_class})', subject_label]
                    dico_axioms[subject_class] = list


# remplissage de la dataframe axioms | filling of the axioms dataframe
for key, value in dico_axioms.items():
    if key =='Subject_label':
        pass
    else:
        axioms_df.loc[len(axioms_df)] = {'ID': key,'Label EN': value[1], 'Parent Class': value[0]}
for key, value in dico_annotations.items():
    axioms_df.loc[len(axioms_df)] = {'ID': key,'Label EN': value[1], 'Annotation': value[0]}
    
# print(component_df)
# print(axioms_df)
output_df = pd.merge(component_df, axioms_df, how='outer')
template_df = pd.merge(output_df, translation_df, how='outer')

idx = template_df[template_df['ID'] == 'ID']
print(idx)
idx = template_df[template_df['ID'] == 'ID'].index.item()

# # Move target row to first element of list.
new_index = [idx] + [i for i in range(len(template_df)) if i != idx]
#print(new_index)
template_df = template_df.reindex(new_index).reset_index(drop=True)
print(template_df)

print ('Creation of PROMOT template file')
# Conversion de la dataframe en un template ROBOT | Convert of the dataframe into a ROBOT template
template_df.to_csv('../templates/promot-component-auto.tsv', sep='\t', index=False)