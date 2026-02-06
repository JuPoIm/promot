# python3.12.3
# utf-8
# But du script : retrouver des phenotypes et des maladies en relation avec une liste de gene dans HPO
# Autrice :  Juliette POTIER, ingénieure d'étude NLP, INSERM et Institut Imagine
# date de création : 25/11/2024 (INSERM)
# date de version : 26/02/2025 (Imagine : modif pour que ça fonctionne avec pipeline OPMD Form fr
#                                                      ajout des codes CMS et CM      )
#  
# ------------------------------------------------------------------------------------#
#                           ATTENTION AUX DONNEES D'ENTREE                            #
# ------------------------------------------------------------------------------------#

# ------------ Imports utilisés ------------#
import csv
import re

# ------------ Variables globales ------------#
# Données maladies
dico_orpha_CMS = {'ORPHA:590'  : 'Congenital myasthenic syndrome',
                'ORPHA:98913'  : 'Postsynaptic congenital myasthenic syndromes',
                'ORPHA:98914'  : 'Presynaptic congenital myasthenic syndromes',
                'ORPHA:98915'  : 'Synaptic congenital myasthenic syndromes',
                'ORPHA:353327' : 'Congenital myasthenic syndromes with glycosylation defect'}

dico_omim_CMS = {'OMIM:617143' : 'Congenital myasthenic syndrome',
                'OMIM:616720'  : 'Postsynaptic congenital myasthenic syndromes',
                'OMIM:618197'  : 'Presynaptic congenital myasthenic syndromes',
                'OMIM:603034'  : 'Synaptic congenital myasthenic syndromes',
                'OMIM:610542'  : 'Congenital myasthenic syndromes with glycosylation defect'}

dico_orpha_CM = {'ORPHA:97245' : 'Congenital myopathy',
                'ORPHA:3010'   : 'Qazi-Markouizos syndrome',
                'ORPHA:1358'   : 'Carey-Fineman-Ziter syndrome',
                'ORPHA:2020'   : 'Congenital fiber-type disproportion myopathy',
                'ORPHA:2593'   : 'Tubular aggregate myopathy',
                'ORPHA:3068'   : 'Intellectual disability-myopathy-short stature-endocrine defect syndrome',
                'ORPHA:595'    : 'Centronuclear myopathy',
                'ORPHA:596'    : 'X-linked centronuclear myopathy',
                'ORPHA:169186' : 'Autosomal recessive centronuclear myopathy',
                'ORPHA:169189' : 'Autosomal dominant centronuclear myopathy',
                'ORPHA:456328' : 'X-linked myotubular myopathy-abnormal genitalia syndrome',
                'ORPHA:604680' : 'Symptomatic form of X-linked centronuclear myopathy in female carriers',
                'ORPHA:319160' : 'Congenital myopathy with internal nuclei and atypical cores',
                'ORPHA:53698'  : 'Myosin storage myopathy',
                'ORPHA:636965' : 'Autosomal dominant myosin storage myopathy',
                'ORPHA:636970' : 'Autosomal recessive myosin storage myopathy',
                'ORPHA:97232'  : 'Fingerprint body myopathy',
                'ORPHA:97239'  : 'Reducing body myopathy',
                'ORPHA:97240'  : 'Zebra body myopathy',
                'ORPHA:98904'  : 'Congenital myopathy with excess of thin filaments',
                'ORPHA:99741'  : 'King-Denborough syndrome',
                'ORPHA:168572' : 'Native American myopathy',
                'ORPHA:171881' : 'Cap myopathy',
                'ORPHA:171886' : 'Cylindrical spirals myopathy',
                'ORPHA:171889' : 'Myopathy with hexagonally cross-linked tubular arrays',
                'ORPHA:172976' : 'Congenital myopathy with cores',
                'ORPHA:597'    : 'Central core disease',
                'ORPHA:598'    : 'Multiminicore myopathy',
                'ORPHA:98905'  : 'Congenital multicore myopathy with external ophthalmoplegia',
                'ORPHA:178145' : 'Moderate multiminicore disease with hand involvement',
                'ORPHA:178148' : 'Antenatal multiminicore disease with arthrogryposis multiplex congenita',
                'ORPHA:324604' : 'Classic multiminicore myopathy',
                'ORPHA:210163' : 'Congenital lethal myopathy, Compton-North type',
                'ORPHA:324581' : 'Benign Samaritan congenital myopathy',
                'ORPHA:363409' : 'Fetal akinesia-cerebral and retinal hemorrhage syndrome',
                'ORPHA:424107' : 'Congenital myopathy with myasthenic-like onset',
                'ORPHA:439212' : 'Early-onset myopathy-areflexia-respiratory distress-dysphagia syndrome',
                'ORPHA:544602' : 'Congenital myopathy with reduced type 2 muscle fibers',
                'ORPHA:447974' : 'Klippel-Feil anomaly-myopathy-facial dysmorphism syndrome',
                'ORPHA:467176' : 'Severe hypotonia-psychomotor developmental delay-strabismus-cardiac septal defect syndrome',
                'ORPHA:457074' : 'Congenital nemaline myopathy',
                'ORPHA:98902'  : 'Amish nemaline myopathy',
                'ORPHA:171430' : 'Severe congenital nemaline myopathy',
                'ORPHA:171433' : 'Intermediate nemaline myopathy',
                'ORPHA:171436' : 'Typical nemaline myopathy'}

dico_omim_CM = {'Qazi-Markouizos syndrome'                                                 : 'OMIM:600096',
                'Carey-Fineman-Ziter syndrome'                                             : 'OMIM:254940',
                'Congenital fiber-type disproportion myopathy'                             : 'OMIM:255310',
                'Tubular aggregate myopathy'                                               : 'OMIM:160565',
                'Intellectual disability-myopathy-short stature-endocrine defect syndrome' : 'OMIM:253320',
                'X-linked centronuclear myopathy'                                          : 'OMIM:310400',
                'Autosomal recessive centronuclear myopathy'                               : 'OMIM:255200',
                'Autosomal dominant centronuclear myopathy'                                : 'OMIM:160150',
                'X-linked myotubular myopathy-abnormal genitalia syndrome'                 : 'OMIM:300219',
                'Symptomatic form of X-linked centronuclear myopathy in female carriers'   : 'OMIM:310400',
                'Congenital myopathy with internal nuclei and atypical cores'              : 'OMIM:614807',
                'Myosin storage myopathy'                                                  : 'OMIM:255160',
                'Autosomal dominant myosin storage myopathy'                               : 'OMIM:608358',
                'Autosomal recessive myosin storage myopathy'                              : 'OMIM:255160',
                'Fingerprint body myopathy'                                                : 'OMIM:305550',
                'Reducing body myopathy'                                                   : 'OMIM:300717',
                'Congenital myopathy with excess of thin filaments'                        : 'OMIM:161800',
                'King-Denborough syndrome'                                                 : 'OMIM:619542',
                'Native American myopathy'                                                 : 'OMIM:255995',
                'Cap myopathy'                                                             : 'OMIM:609284',
                'Central core disease'                                                     : 'OMIM:117000',
                'Multiminicore myopathy'                                                   : 'OMIM:117000',
                'Congenital multicore myopathy with external ophthalmoplegia'              : 'OMIM:255320',
                'Moderate multiminicore disease with hand involvement'                     : 'OMIM:117000',
                'Classic multiminicore myopathy'                                           : 'OMIM:602771',
                'Congenital lethal myopathy, Compton-North type'                           : 'OMIM:612540',
                'Fetal akinesia-cerebral and retinal hemorrhage syndrome'                  : 'OMIM:615368',
                'Early-onset myopathy-areflexia-respiratory distress-dysphagia syndrome'   : 'OMIM:614399',
                'Congenital myopathy with reduced type 2 muscle fibers'                    : 'OMIM:618414',
                'Klippel-Feil anomaly-myopathy-facial dysmorphism syndrome'                : 'OMIM:616549',
                'Severe hypotonia-psychomotor developmental delay-strabismus-cardiac septal defect syndrome' : 'OMIM:616816',
                'Amish nemaline myopathy'                                                  : 'OMIM:605355',
                'Severe congenital nemaline myopathy'                                      : 'OMIM:615348',
                'Intermediate nemaline myopathy'                                           : 'OMIM:609284',
                'Typical nemaline myopathy'                                                : 'OMIM:161800'}

dico_orpha_OPMD = {'ORPHA:270'  : 'Oculopharyngeal Muscular Dystrophy'}
dico_omim_OPMD  = {'OMIM:164300' : 'Oculopharyngeal Muscular Dystrophy'}

dico_orpha_MM = {#'ORPHA:593' : 'Myofibrillar myopathy',
                'ORPHA:98909'  : 'Desminopathy'}
dico_omim_MM  = {'OMIM:601419'   : 'Desminopathy'}

# Données gènes
dico_gen_CMS  = {'1145' : 'CHRNE', '285489': 'DOK7', '8292': 'COLQ', '5913': 'RAPSN', '2673': 'GFPT1', '29925': 'GMPPB'} # Congenital myasthenic syndromes
dico_gen_CM   = {'6261' : 'RYR1', '7273': 'TTN', '4703': 'NEB', '4534': 'MTM1', '58': 'ACTA1', '57190': 'SELENON'} # Congenital myopathies
dico_gen_OPMD = {'8106' : 'PABPN1'}
dico_gen_MM   = {'1674' : 'DES'}

# Dico pour récupérer les bonnes données
tar_orpha = {'OPMD' : dico_orpha_OPMD, 'CM' : dico_orpha_CM, 'CMS' : dico_orpha_CMS, 'MM' : dico_orpha_MM}
tar_omim  = {'OPMD' : dico_omim_OPMD, 'CM' : dico_omim_CM, 'CMS' : dico_omim_CMS, 'MM' : dico_omim_MM}
tar_gen   = {'OPMD' : dico_gen_OPMD, 'CM' : dico_gen_CM, 'CMS' : dico_gen_CMS, 'MM' : dico_gen_MM}


# ------------ Fonctions globales ------------#
# Nettoyage des codes HPO
def id_cleaner(id):
    id_bis = re.sub(r'(\'| )', '', id)
    id_ter = re.sub(r'(])', '', id_bis)
    id_qua = re.sub(r'(\[)', '', id_ter)
    return id_qua

# ------------------------------------------------------------------------------------#
#                                        MAIN                                         #
# ------------------------------------------------------------------------------------#
# Mapping avec les phénotypes des gènes et des maladies étudiées 
#def mapping_genes (ifile, gfile, maladie, ofile):
def mapping_genes (gfile, maladie):
    a_ecrire = []
    compteur = 0
    """
    # ------------ 1/3 Récupération des résultats du mapping HPO ------------#
    with open(ifile, newline='', encoding='utf-8') as file:
        reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for row in reader:
            a_ecrire.append(row[0:5])
            variable = row[2]
            id = row[1] #5
            ident = id_cleaner(id)
            if ident !='HPOID' : #and len(statut) != 3:
                compteur = compteur +1
            else: 
                pass
    print(f"{compteur} codes mappés pour {maladie}.\n")
    """
    outputfile= f"./resultats/NO_Liste_phenos_genes_"+ maladie +".csv"
    # Création du dico : gène de la maladie -> liste de phéno associée
    dico_pheno_gen = {}
    for id_gene, nom_gene in tar_gen[maladie].items():
            dico_pheno_gen[nom_gene] = []
    # Ouverture et parcours du fichier gene_to_pheno
    with open(gfile, newline='', encoding='utf-8') as file:
        reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        # ------------ 2/3 Récupération des phénotypes pour chaque gène associé à la maladie ------------#    
        with open(outputfile, 'w', newline='', encoding='utf-8') as csvfile:
            gene_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            compteur_gen = 0
            for row in reader:
                gene_name = id_cleaner(row[1])
                hpo_id = row[2]
                hpo_label = row[3]
                dis_id = row[5]
                ident = id_cleaner(hpo_id)
                for id_gene, nom_gene in tar_gen[maladie].items():
                    if gene_name == nom_gene and ident not in dico_pheno_gen[nom_gene]:
                        compteur_gen += 1
                        dico_pheno_gen[nom_gene].append(ident)
                        gene_writer.writerow([nom_gene, ident, hpo_label])
    
    compteur_dis = 0
    outputfile= f"./resultats/Liste_phenos_genes_ORPHA_"+ maladie +"_3.csv"
    dico_pheno_dis = {}
    for id_orpha, disease in tar_orpha[maladie].items():
            dico_pheno_dis[disease] = []
    # ------------ 2/3 Récupération des phénotypes orpha pour la maladie ------------#
    with open(gfile, newline='', encoding='utf-8') as file:
        reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        with open(outputfile, 'w', newline='', encoding='utf-8') as csvfile:
            orpha_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            for row in reader:
                hpo_id = row[2]
                ident = id_cleaner(hpo_id)
                hpo_label = row[3]
                dis_id = row[5]
                dis_name = row[6]
                for id_orpha, disease in tar_orpha[maladie].items():
                    if id_orpha == dis_id and ident not in dico_pheno_dis[disease]:
                        compteur_dis += 1
                        dico_pheno_dis[disease].append(ident)
                        orpha_writer.writerow([dis_id, dis_name, ident, hpo_label])
        #print(f"NB de phénotypes pour les codes orpha du groupe {maladie} dans le fichier genes_to_phenotype : \n {compteur_dis}")
    with open(f"./resultats/STAT_phenos_genes_ORPHA_"+ maladie +"_3.csv", 'w', newline='', encoding='utf-8') as csvfile:
        stat_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for k, v in dico_pheno_dis.items():
            nb = len(v)
            print (f"{k} : {nb} phénotypes.")
            stat_writer.writerow([k,nb])

    dico_pheno_dis = {}
    for disease, id_omim in tar_omim[maladie].items():
            dico_pheno_dis[id_omim] = []
    omimfile= f"./resultats/Liste_phenos_genes_OMIM_"+ maladie +"_3.csv"
    # ------------ 2/3 Récupération n°2 des phénotypes omim pour la maladie ------------#
    with open(gfile, newline='', encoding='utf-8') as file:
        reader = csv.reader(file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        # ------------------------------------------------------------------------------------
        #
        #              ATTENTION AUX DICTIONNAIRES : {code : nom} OU {nom : code}
        #
        # ------------------------------------------------------------------------------------
        with open(omimfile, 'w', newline='', encoding='utf-8') as csvfile:
            omim_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            for row in reader:
                hpo_id = row[2]
                ident = id_cleaner(hpo_id)
                hpo_label = row[3]
                dis_id = row[5] #" code 117000"
                dis_name = row[6] # la liste des maladies
                for disease, id_omim in tar_omim[maladie].items():
                    if id_omim == dis_id and ident not in dico_pheno_dis[dis_id]:
                        compteur_dis += 1
                        dico_pheno_dis[dis_id].append(ident)
                        omim_writer.writerow([dis_id, dis_name, ident, hpo_label])

    with open(f"./resultats/STAT_phenos_genes_OMIM_"+ maladie +"_3.csv", 'w', newline='', encoding='utf-8') as csvfile:
        stat_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for k, v in dico_pheno_dis.items():
            nb = len(v)
            print (f"{k} : {nb} phénotypes.")
            stat_writer.writerow([k,nb])

    print(f"NB de phénotypes pour les gènes associés à la maladie dans le fichier genes_to_phenotype : \n {compteur_gen}")
    print(f"NB de phénotypes pour les maladies du groupe {maladie} dans le fichier genes_to_phenotype : \n {compteur_dis}")

    """
    # ------------ 3/3 Ecriture des mappings résultats HPO et fichiers gene ------------#
    
    with open(f'List_pheno_dis_' + maladie +'.csv', 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        writer.writerow(['list pheno dis'])
        for v in dico_pheno_dis.values():
            writer.writerow([v])
    
    # ------------ 3/3 Ecriture des mappings résultats HPO et fichiers gene ------------#
    
    with open(f'List_pheno_gen_' + maladie +'.csv', 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        writer.writerow(['liste pheno gen'])
        for v in dico_pheno_gen.values():
            writer.writerow([v])
      

    # ------------ 3/3 Ecriture des mappings résultats HPO et fichiers gene ------------#
    with open(ofile, 'w', newline='', encoding='utf-8') as csvfile:
        gene_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        compteur_map_gen = 0
        compteur_map_dis = 0
        for i in range(len(a_ecrire)) :
            variable = a_ecrire[i][0]
            to_write = a_ecrire[i]    
            if variable == 'ID VARIABLE' or variable == 'Variable' or variable == 'Variable de départ':
                # ajout des gènes dans l'entête
                for key in dico_pheno_gen.keys():
                    to_write.append(key)
                to_write.append('Trouvé pour 1 gène')
                # ajout des maladies dans l'entête
                for key in dico_pheno_dis.keys():
                    code_orpha = [cle for cle, valeur in tar_orpha[maladie].items() if valeur == key]
                    to_write.append(id_cleaner(str(code_orpha)))
                to_write.append('Trouvé pour 1 maladie')
            else :
                id = a_ecrire[i][1] #
                code_hpo = id_cleaner(id)
                # écriture des résultats par gene
                flag_gen = False
                for gen, listphen in dico_pheno_gen.items():
                    #print (gen)
                    #print (listphen)
                    if code_hpo in listphen :
                        compteur_map_gen +=1
                        to_write.append('OUI')
                        flag_gen = True
                    else :
                        to_write.append('NON')
                if flag_gen == True:
                    to_write.append('OUI')
                else :
                    to_write.append('NON')
                # écriture des résultats par maladie
                flag_dis = False
                for dis, listphen in dico_pheno_dis.items():
                    if code_hpo in listphen :
                        compteur_map_dis +=1
                        to_write.append('OUI')
                        flag_dis = True
                    else :
                        to_write.append('NON')
                if flag_dis == True:
                    to_write.append('OUI')
                else :
                    to_write.append('NON') 
            gene_writer.writerow(to_write)

        print (f"{compteur_map_gen} correspondance(s) entre les phénotypes des gènes et les phéno mappés.\n")
        print (f"{compteur_map_dis} correspondance(s) entre les phénotypes des maladies et les phéno mappés.\n")
        """