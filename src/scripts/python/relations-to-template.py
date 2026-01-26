# python3.12.3
# utf-8
# Autrice / Author : juliette.potier@institutimagine.org
# GOAL : script to create the template ROBOT with the relations
# BUT : créer le template ROBOT avec les relations
# date de création / Creation date : 22/12/2025
# date de version / Version date : 22/12/2025

import csv
import pandas as pd

# import des templates ROBOT existant en deux dataframe pandas pour la base et les traductions ICF
print ('Import dataframe')
component_df = pd.read_csv("../templates/promot-component-base.tsv", sep="\t")
translation_df = pd.read_csv("../templates/icf_labels_es-fr.tsv", sep="\t")

# axioms_df creation with 
# création de la dataframe des axioms au format template
print ('Creation dataframe')
axioms_df = pd.DataFrame(columns = ['ID', 'Label EN', 'Annotation', 'Type', 'Parent Class'])
axioms_df.loc[0] = {'ID': 'ID', 'Label EN': 'A rdfs:label', 'Annotation' : 'A PROMOT:1000001 SPLIT=|', 'Type': 'TYPE', 'Parent Class': 'SC % SPLIT=|'}


dico_axioms = {}
dico_annotations = {}
list_objectprop = []
list_annotationprop = []

print ('Ouverture fichier RELATION')
# Read csv file with relations and fill dictionnary with relations
with open('../data/RELATIONS.tsv', newline='', encoding='utf-8') as tsvfile:
    reader = csv.reader(tsvfile, delimiter = '\t', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
    subject_class = str()
    subject_label = str()
    predicate = str()
    object_class = str()
    #print ('ouverture fichier')
    for row in reader:
        #print ('-- lecture ligne')
        if 'Subject iri' in row[0]: # get the object property used as a predicate
            pass
        elif row[2] == 'PROMOT:1000001': # s'il s'agit d'une annotation property
            subject_class = row[0]
            subject_label = row[1]
            predicate = row[2]
            data = row[6]
            if predicate in list_annotationprop :
                pass
            else :
                list_annotationprop.append(predicate)
            if subject_class in dico_annotations.keys(): # if there already is a relation using the class as a subject
                #print ('----- ancien sujet')
                dico_annotations[subject_class][0] = f'{dico_annotations[subject_class][0]}|{data}'
            else: # if no relation using the class as a subject already exists
                print ('------ Nouveau sujet')
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
            #print ('----- jusqu\'ici tout va bien')
            if subject_class in dico_axioms.keys(): # if there already is a relation using the class as a subject
                #print ('----- ancien sujet')
                dico_axioms[subject_class][0] = f'{dico_axioms[subject_class][0]}|({predicate} {expression} {object_class})'
            else: # if no relation using the class as a subject already exists
                print ('------ Nouveau sujet')
                list = [f'({predicate} {expression} {object_class})', subject_label]
                dico_axioms[subject_class] = list

# ajout des propriétés et de leur types dans les premières lignes du dataframe axioms INUTILE CAR DANS BASE DEJA
for i in list_objectprop:
    print(f'object property {i}')
    axioms_df.loc[len(axioms_df)] = {'ID': i,'TYPE': 'Object property'}
for i in list_annotationprop:
    print(f'annotation property {i}')
    axioms_df.loc[len(axioms_df)] = {'ID': i,'TYPE': 'Annotation property'}

# remplissage de la dataframe axioms
for key, value in dico_axioms.items():
    axioms_df.loc[len(axioms_df)] = {'ID': key,'Label EN': value[1], 'Parent Class': value[0]}
for key, value in dico_annotations.items():
    axioms_df.loc[len(axioms_df)] = {'ID': key,'Label EN': value[1], 'Annotation': value[0]}

output_df = pd.merge(component_df, axioms_df, how='outer')
output_df.to_csv('../templates/promot-component-test-auto-1.tsv', sep='\t', index=False)

template_df = pd.merge(output_df, translation_df, how='outer')


# ajout des axiomes du fichier RELATIONS dans la dataframe de base du component
# for index, row in component_df.iterrows():
#     for indice, ligne in axioms_df.iterrows():
#         if row['ID'] == ligne['ID']:
#             if row['Parent Class'] == 'NaN':
#                 component_df[index, 'Parent Class'] = axioms_df[indice, 'Parent Class']
#             else:
#                 print ('ID pas égaux entre component et axioms dataframe')

# fusion de la dataframe avec traductions ICF avec la dataframe de base du component
# on écrase les label anglais (supprime les potentielles erreurs pour les labels ICF)
# for index, row in component_df.iterrows():
#     for indice, ligne in translation_df.iterrows():
#         if row['ID'] == ligne['ID']:
#             component_df[index, 'Label EN'] = translation_df[indice, 'Label EN']
#             component_df[index, 'Label FR'] = translation_df[indice, 'Label FR']
#             component_df[index, 'Label ES'] = translation_df[indice, 'Label ES']
#             component_df[index, 'Comment'] = translation_df[indice, 'Comment']
#         else:
#             component_df.loc[len(component_df)] = ligne

# Conversion de la dataframe en un template ROBOT
template_df.to_csv('../templates/promot-component-test-auto-2.tsv', sep='\t', index=False)
# axioms_df.to_csv('../templates/promot_axioms.tsv', sep='\t', index=False)