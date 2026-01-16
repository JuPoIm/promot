# python3.12.3
# utf-8
# Autrice / Author : juliette.potier@institutimagine.org
# GOAL : script to create the template ROBOT with the relations
# BUT : créer le template ROBOT avec les relations
# date de création / Creation date : 22/12/2025
# date de version / Version date : 22/12/2025

import csv
import pandas as pd


#df = pd.read_csv("mon_fichier.tsv", sep="\t")

# df creation with 
# création de la dataframe au format template
template_df = pd.DataFrame(columns = ['ID', 'Label EN', 'Annotation', 'TYPE', 'Parent Class'])
template_df.loc[0] = {'ID': 'ID', 'Label EN': 'A rdfs:label', 'Annotation' : 'A PROMOT:1000001 SPLIT=|', 'TYPE': 'TYPE', 'Parent Class': 'SC % SPLIT=|'}
dico_axioms = {}
dico_annotations = {}
list_objectprop = []
list_annotationprop = []


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

for i in list_objectprop:
    print(f'object property {i}')
    template_df.loc[len(template_df)] = {'ID': i,'TYPE': 'Object property'}
for i in list_annotationprop:
    print(f'annotation property {i}')
    template_df.loc[len(template_df)] = {'ID': i,'TYPE': 'Annotation property'}
    
for key, value in dico_axioms.items():
    template_df.loc[len(template_df)] = {'ID': key,'Label EN': value[1], 'Parent Class': value[0]}
for key, value in dico_annotations.items():
    template_df.loc[len(template_df)] = {'ID': key,'Label EN': value[1], 'Annotation': value[0]}

template_df.to_csv('../templates/promot_axioms.tsv', sep='\t', index=False)