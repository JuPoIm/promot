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
import pandas as pd

# ------------ Variables globales ------------#
# Données maladies - update du 02/04/25
# dico_codes_CMS = {}
# dico_codes_CM = {}
# dico_codes_OPMD = {}
# Données gènes
# dico_gen_CMS  = {} # Congenital myasthenic syndromes
# dico_gen_CM   = {} # Congenital myopathies
# dico_gen_OPMD = {}

# DISEASE GROUP	| GENE NAME
genes_df = pd.read_csv("../../data/scripts/genes_names.tsv")
# DISEASE GROUP	| DISEASE NAME	| ORPHA CODE | OMIM CODE
diseases_df = pd.read_csv("../../data/scripts/diseases_codes.tsv")

# ncbi_gene_id	| gene_symbol	| hpo_id	| hpo_name	| frequency	| disease_id
data_df = pd.read_csv("../../data/scripts/genes_to_phenotype.txt")

### creation de df de travail
columns = ['Disease group', 'Gene name', 'HPO id', 'HPO name' 'Disease id', 'Disease name']
results_df = pd.DataFrame(columns=columns)

columns = ['Disease name', 'Disease id', 'NB of HPO codes']
stats_diseases_df = pd.DataFrame(columns=columns)

columns = ['Gene name', 'NB of HPO codes']
stats_genes_df = pd.DataFrame(columns=columns)

with open('../data/genes_to_phenotype_24-12-12.txt', newline='', encoding='utf-8') as file:
    reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)  
    for index, row in genes_df.iterrows():
        disease = row['DISEASE GROUP']
        gene = row['GENE NAME']
        for line in reader:
             if 


        maladie = 'OPMD'
        compteur_maladies = {}
        for code, name in dico_codes_OPMD.items():
            compteur_maladies[name] = 0 
        dico_pheno_dis = {}
        for code, name in dico_codes_OPMD.items():
            dico_pheno_dis[name] = []

        compteur_genes = {}
        for code, name in dico_gen_OPMD.items():
            compteur_genes[name] = 0

        with open('./Data/genes_diseases/24-12-12/genes_to_phenotype_24-12-12_upgraded-codes2.txt', newline='', encoding='utf-8') as file:
            reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)  
            outputfile= f"./resultats/Liste_phenos_genes-"+ maladie +"_09-04-25_positifs.csv"
            # Création du dico : gène de la maladie -> liste de phéno associée
            dico_pheno_gen = {}
            for id_gene, nom_gene in dico_gen_OPMD.items():
                dico_pheno_gen[nom_gene] = []
            # ------------ 2/3 Récupération des phénotypes pour chaque gène associé à la maladie ------------#    
            with open(outputfile, 'w', newline='', encoding='utf-8') as csvfile:
                gene_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
                compteur_gen = 0
                for row in reader:
                    gene_name = row[1]
                    hpo_id = row[2]
                    hpo_label = row[3]
                    dis_id = row[5]
                    ident = hpo_id
                    if gene_name in dico_gen_OPMD.values() :
                        if dis_id in dico_codes_OPMD.keys() :
                        #compteur_gen += 1
                        #dico_pheno_gen[nom_gene].append(ident)
                            if ident not in dico_pheno_gen[gene_name]:
                                compteur_genes[gene_name] += 1
                                dico_pheno_gen[gene_name].append(ident)
                            dis_name = dico_codes_OPMD[dis_id] 
                            if hpo_id not in dico_pheno_dis[dis_name] :
                                compteur_maladies[dis_name] +=1
                                dico_pheno_dis[dis_name].append(hpo_id)
                            gene_writer.writerow([gene_name, ident, hpo_label, dis_id, dico_codes_OPMD[dis_id]])
                        #else :
                        #    gene_writer.writerow([gene_name, ident, hpo_label])
        with open(f"./resultats/STAT_phenos_genes_maladies_"+ maladie +"_sdoub_2.csv", 'w', newline='', encoding='utf-8') as csvfile:
            stat_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            for nom, nombre in compteur_maladies.items():
                    stat_writer.writerow([nom, [k for k, v in dico_codes_OPMD.items() if v == nom], nombre]) 
            for nom, nombre in compteur_genes.items():
                    stat_writer.writerow([nom, [v for k, v in dico_gen_CMS.items() if v == nom], nombre])    
# ------------------------------------------------------------------------------------#
#                                        MAIN                                         #
# ------------------------------------------------------------------------------------#
# # récupération des 
# with open('../data/diseases_codes.tsv', newline='', encoding='utf-8') as file:
#     reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
#     for row in reader:
#         group = row[0]
#         name = row[1]
#         orpha = row[2]
#         omim = row[3]
#         if group == 'CM':
#             dico_codes_CM[orpha] = name
#             dico_codes_CM[omim] = name
#         elif group == 'CMS':
#             dico_codes_CMS[orpha] = name
#             dico_codes_CMS[omim] = name
#         elif group == 'OPMD':
#             dico_codes_OPMD[orpha] = name
#             dico_codes_OPMD[omim] = name
            
# # récupération des 
# with open('../data/gene_codes.tsv', newline='', encoding='utf-8') as file:
#     reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
#     for row in reader:
#         group = row[0]
#         code = row[1]
#         name = row[2]
#         if group == 'CM':
#             dico_gen_CM[code] = name
#         elif group == 'CMS':
#             dico_gen_CMS[code] = name
#         elif group == 'OPMD':
#             dico_gen_OPMD[code] = name

#### fin modifs 29/10/2025
maladie = 'CMS'
compteur_maladies = {}
for code, name in dico_codes_CMS.items():
    compteur_maladies[name] = 0

data = pd.DataFrame(index = [name for name in compteur_maladies.keys()], columns=[gene for gene in dico_gen_CMS.values()])

dico_pheno_dis = {}
for code, name in dico_codes_CMS.items():
    dico_pheno_dis[name] = []

compteur_genes = {}
for code, name in dico_gen_CMS.items():
    compteur_genes[name] = 0

with open('./Data/genes_diseases/24-12-12/genes_to_phenotype_24-12-12_upgraded-codes2.txt', newline='', encoding='utf-8') as file:
    reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)  
    outputfile= f"./resultats/Liste_phenos_genes-"+ maladie +"_09-04-25_positifs.csv"
    # Création du dico : gène de la maladie -> liste de phéno associée
    dico_pheno_gen = {}
    for id_gene, nom_gene in dico_gen_CMS.items():
        dico_pheno_gen[nom_gene] = []
    # ------------ 2/3 Récupération des phénotypes pour chaque gène associé à la maladie ------------#    
    with open(outputfile, 'w', newline='', encoding='utf-8') as csvfile:
        gene_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for row in reader:
            gene_name = row[1]
            hpo_id = row[2]
            hpo_label = row[3]
            dis_id = row[5]
            ident = hpo_id
            if gene_name in dico_gen_CMS.values() :
                if dis_id in dico_codes_CMS.keys()  :
                    if ident not in dico_pheno_gen[gene_name]:
                        compteur_genes[gene_name] += 1
                        dico_pheno_gen[gene_name].append(ident)
                    dis_name = dico_codes_CMS[dis_id] 
                    if hpo_id not in dico_pheno_dis[dis_name] :
                        #data.at[dis_name, gene_name] = 1
                        compteur_maladies[dis_name] +=1
                        dico_pheno_dis[dis_name].append(hpo_id)
                    gene_writer.writerow([gene_name, ident, hpo_label, dis_id, dico_codes_CMS[dis_id]])
                #else :
                #    gene_writer.writerow([gene_name, ident, hpo_label])
#print(data)


with open(f"./resultats/STAT_phenos_genes_maladies_"+ maladie +"_sdoub-genes3.csv", 'w', newline='', encoding='utf-8') as csvfile:
    stat_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for nom, nombre in compteur_maladies.items():
            stat_writer.writerow([nom, [k for k, v in dico_codes_CMS.items() if v == nom], nombre])    
    for nom, nombre in compteur_genes.items():
            stat_writer.writerow([nom, [v for k, v in dico_gen_CMS.items() if v == nom], nombre])    

maladie = 'CM'
compteur_maladies = {}
for code, name in dico_codes_CM.items():
    compteur_maladies[name] = 0 
dico_pheno_dis = {}
for code, name in dico_codes_CM.items():
    dico_pheno_dis[name] = [] 

compteur_genes = {}
for code, name in dico_gen_CM.items():
    compteur_genes[name] = 0

with open('./Data/genes_diseases/24-12-12/genes_to_phenotype_24-12-12_upgraded-codes2.txt', newline='', encoding='utf-8') as file:
    reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)  
    outputfile= f"./resultats/Liste_phenos_genes-"+ maladie +"_09-04-25_positifs.csv"
    # Création du dico : gène de la maladie -> liste de phéno associée
    dico_pheno_gen = {}
    for id_gene, nom_gene in dico_gen_CM.items():
        dico_pheno_gen[nom_gene] = []
    # ------------ 2/3 Récupération des phénotypes pour chaque gène associé à la maladie ------------#    
    with open(outputfile, 'w', newline='', encoding='utf-8') as csvfile:
        gene_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        compteur_gen = 0
        for row in reader:
            gene_name = row[1]
            hpo_id = row[2]
            hpo_label = row[3]
            dis_id = row[5]
            ident = hpo_id
            if gene_name in dico_gen_CM.values() :
                if dis_id in dico_codes_CM.keys() :
                #compteur_gen += 1
                #dico_pheno_gen[nom_gene].append(ident)
                    if ident not in dico_pheno_gen[gene_name]:
                        compteur_genes[gene_name] += 1
                        dico_pheno_gen[gene_name].append(ident)
                    dis_name = dico_codes_CM[dis_id]
                    if hpo_id not in dico_pheno_dis[dis_name] :
                        compteur_maladies[dis_name] += 1
                        dico_pheno_dis[dis_name].append(hpo_id)
                    gene_writer.writerow([gene_name, ident, hpo_label, dis_id, dico_codes_CM[dis_id]])
                #else :
                #    gene_writer.writerow([gene_name, ident, hpo_label])

with open(f"./resultats/STAT_phenos_genes_maladies_"+ maladie +"_sdoub_2.csv", 'w', newline='', encoding='utf-8') as csvfile:
    stat_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for nom, nombre in compteur_maladies.items():
            stat_writer.writerow([nom, [k for k, v in dico_codes_CM.items() if v == nom], nombre]) 
    for nom, nombre in compteur_genes.items():
            stat_writer.writerow([nom, [v for k, v in dico_gen_CMS.items() if v == nom], nombre])    

maladie = 'OPMD'
compteur_maladies = {}
for code, name in dico_codes_OPMD.items():
    compteur_maladies[name] = 0 
dico_pheno_dis = {}
for code, name in dico_codes_OPMD.items():
    dico_pheno_dis[name] = []

compteur_genes = {}
for code, name in dico_gen_OPMD.items():
    compteur_genes[name] = 0

with open('./Data/genes_diseases/24-12-12/genes_to_phenotype_24-12-12_upgraded-codes2.txt', newline='', encoding='utf-8') as file:
    reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)  
    outputfile= f"./resultats/Liste_phenos_genes-"+ maladie +"_09-04-25_positifs.csv"
    # Création du dico : gène de la maladie -> liste de phéno associée
    dico_pheno_gen = {}
    for id_gene, nom_gene in dico_gen_OPMD.items():
         dico_pheno_gen[nom_gene] = []
    # ------------ 2/3 Récupération des phénotypes pour chaque gène associé à la maladie ------------#    
    with open(outputfile, 'w', newline='', encoding='utf-8') as csvfile:
        gene_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        compteur_gen = 0
        for row in reader:
            gene_name = row[1]
            hpo_id = row[2]
            hpo_label = row[3]
            dis_id = row[5]
            ident = hpo_id
            if gene_name in dico_gen_OPMD.values() :
                if dis_id in dico_codes_OPMD.keys() :
                #compteur_gen += 1
                #dico_pheno_gen[nom_gene].append(ident)
                    if ident not in dico_pheno_gen[gene_name]:
                        compteur_genes[gene_name] += 1
                        dico_pheno_gen[gene_name].append(ident)
                    dis_name = dico_codes_OPMD[dis_id] 
                    if hpo_id not in dico_pheno_dis[dis_name] :
                        compteur_maladies[dis_name] +=1
                        dico_pheno_dis[dis_name].append(hpo_id)
                    gene_writer.writerow([gene_name, ident, hpo_label, dis_id, dico_codes_OPMD[dis_id]])
                #else :
                #    gene_writer.writerow([gene_name, ident, hpo_label])
with open(f"./resultats/STAT_phenos_genes_maladies_"+ maladie +"_sdoub_2.csv", 'w', newline='', encoding='utf-8') as csvfile:
    stat_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for nom, nombre in compteur_maladies.items():
            stat_writer.writerow([nom, [k for k, v in dico_codes_OPMD.items() if v == nom], nombre]) 
    for nom, nombre in compteur_genes.items():
            stat_writer.writerow([nom, [v for k, v in dico_gen_CMS.items() if v == nom], nombre])    