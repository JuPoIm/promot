# python3.12.3
# utf-8
# But du script : extraire les phenotypes des gènes et des maladies dans HPO
# Autrice :  Juliette POTIER, ingénieure d'étude NLP, INSERM et Institut Imagine
# date de création : 25/11/2024 (sous contrat INSERM)
# date de version : 03/03/2025 (sous contrat Imagine : modif pour que ça fonctionne avec pipeline OPMD Form fr
#                                                      ajout des codes CMS et CM      )
# 07/03/2025 : modification de la liste de maladies + ajout des boucles for pour extraire les phénos depuis mappingGenes.py
# 02/04/2025 : modif de la liste des maladies pour extraction des phenos gènes+maladies
# 09/04/2025 : ajout des compteurs pour chaque maladies
# 29/10/2025 : modif du script pour intégration en ligne

# ------------ Imports utilisés ------------#
import csv
import re
import pandas as pd

# ------------ Fonctions globales ------------#
# Nettoyage des codes HPO
def id_cleaner(id):
    id_bis = re.sub(r'(\'| )', '', id)
    id_ter = re.sub(r'(])', '', id_bis)
    id_qua = re.sub(r'(\[)', '', id_ter)
    return id_qua

# ------------ Variables globales ------------#
# Données maladies - update du 02/04/25
dico_codes_CMS = {}
dico_codes_CM = {}
dico_codes_OPMD = {}

# Données gènes
dico_gen_CMS  = {} # Congenital myasthenic syndromes
dico_gen_CM   = {} # Congenital myopathies
dico_gen_OPMD = {}

# ------------------------------------------------------------------------------------#
#                                        MAIN                                         #
# ------------------------------------------------------------------------------------#
# récupération des
with open(f"./results/HPO_CM_details_updated.csv", 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    with open('../data/HPO_CM_simple.tsv', newline='', encoding='utf-8') as file:
        reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for row in reader:
            pheno_code = row[0]
            status = row[7]
            # récupération des 
            with open('../data/HPO_CM_details.tsv', newline='', encoding='utf-8') as file:
                reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                for row in reader:
                    hpo_code = row[1]
                    if hpo_code == pheno_code:
                        row.append(status)
                        writer.writerow(row)