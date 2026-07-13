# Directory for downloading data used in PROMOT 
# Dossier pour les données téléchargées par PROMOT

## STRUCTURE
### 1. /imports
- Données téléchargées pour la personalisation des imports
- Downloaded data for custom imports

### 2. /promot
- Données pour la génération du template ROBOT PROMOT (éditées à la main)
- Data for creating the PROMOT ROBOT template (hand edited)

### 3. /script
- Données pour les scripts python (en développement)
- Data for python scripts (w.i.p.)


## INSTRUCTIONS 
### 1. IMPORTS
#### SNOMED CT translations and imports
#### Import des traductions de SNOMED CT
##### EN
REQUIREMENTS
1. Create an account and get a UMLS licence on https://www.nlm.nih.gov/healthit/snomedct/international.html 
2. Download the latest SNOMED CT international edition (RF2 files) from https://www.nlm.nih.gov/healthit/snomedct/international.html 
3. Download the latest SNOMED CT Spanish (castellano) edition from https://www.nlm.nih.gov/healthit/snomedct/international.html
4. Add the Spanish (castellano) files to the SNOMED CT international.zip (if needed, create a new .zip such as 'SNOMEDCT_en-es' to combine them)
5. Convert RF2 files to owl with https://github.com/IHTSDO/snomed-owl-toolkit/releases
6. Put the resulting 'ontology-YYYY-MM-DD_EN-ES.owl' in ../data/
7. Create an account and get an licence on https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
8. Download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
9. Put 'terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl' in ../data/
10. Use hereafter code
OR
8. Download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
9. Same process than 1. to 5. with french files added in .zip at stage 3.
10. Custom hereafter code to fit your choice
OR
7. Same process than 1. to 8.
8. Merge the .owl resulting from 4. with terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl (French edition)
9. Put the resulting .owl in ../data/
10. Custom hereafter code to fit your choice

# vielli #
1. Request for a licence and download the latest SNOMED CT international edition (RF2 files) from https://www.nlm.nih.gov/healthit/snomedct/international.html
2. Download the latest SNOMED CT Spanish (castellano) edition from https://www.nlm.nih.gov/healthit/snomedct/international.html
3. Request for a licence and download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
4. Merge the Spanish (castellano) and French files to the SNOMED CT international .zip (or create a new .zip such as 'SNOMEDCT_en-es-fr' if need to combine them)
5. Convert RF2 files to owl with https://github.com/IHTSDO/snomed-owl-toolkit/releases
6. Put the resulting snomed.owl in ../data/

Note that you can also merge the terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl (French edition) to the .owl merging international and Spanish version.

Please consider contacting the SNOMED CT international if your usecase needs it.

###### FR
1. Demander une licence et télécharger la dernière version internationale de SNOMED CT (fichiers RF2) depuis https://www.nlm.nih.gov/healthit/snomedct/international.html
2. Télécharger la dernière version espagnole (castillan) de SNOMED CT depuis https://www.nlm.nih.gov/healthit/snomedct/international.html
3. Demander une licence et télécharger la dernière version française de SNOMED CT depuis https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
4. Ajouter les fichiers .txt des versions espagnole et française au .zip de la version internationale (ou créer une nouvelle archive telle que 'SNOMEDCT_en-es-fr' pour les fusionner si besoin)
5. Convertir l'archive vers owl avec https://github.com/IHTSDO/snomed-owl-toolkit/releases
6. Mettre le résultat dans ../data/

Il est aussi possible de fusionner terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl avec une fusion de la version internationale et espagnole.

Pensez à contacter la SNOMED CT internationnale et/ou l'Agence du numérique en santé si jamais l'usage que vous avez de la SNOMED le requiert.

#### ICF translations and imports
#### Import des traductions pour ICF
ALREADY IMPLEMENTED IN PROMOT.MAKEFILE (cf. translation-mapping-ICF)
##### FR
1. téléchargement de CIF-ASIP 2020
2. export des données intéressantes en csv (URIs, codes, labels)
3. téléchargement des traductions officielles des labels pour ICF 2025
4. export des IRI depuis whofic_import pour filtrer les mappings pour le sssom du projet en 5.
5. exécution du script de mapping via les codes ICF
6. création du SSSOM pour les deux fichiers créés par le script python : un avec les codes utilisés par PROMOT et un avec tous les codes ICF mappés aux codes CIF-ASIP
##### EN
1. Download CIF-ASIP 2020
2. csv export of interesting CIF-ASIP data (URIs, codes, labels)
3. download of translated labels with codes from 2025 ICF browser
4. csv export of IRIs belonging to whofic_import (to create a mapping file with ICF URIs used in PROMOT only)
5. python script that creates 2 files : one with the overall ICF-CIF mapping and a second with ICF URIs used in PROMOT only
6. creates two SSSOM files for the two herebefore files

### 2. PROMOT ###

Hand edited tsv files with axioms to be implemented in PROMOT:
* axioms_anatomy-bf: logical axioms whose subject is an anatomical entity and whose object is a body function
* axioms_anatomy-bs: logical axioms whose subject is an anatomical entity and whose object is a body structure
* axioms_anatomy-pheno: logical axioms whose subject is an anatomical entity and whose object is a phenotype
* axioms_annotations_source: annotation axioms whose subject is a phenotype and whose annotation Is the source justifying the phenotype relation to a disease or a group of disease
* axioms_bf-activity: logical axioms whose subject is a body function and whose object is an activity
* axioms_bs-bf: logical axioms whose subject is a body structure and whose object is a body function
* axioms_bs-pheno: logical axioms whose subject is a body structure and whose object is a phenotype
* axioms_disease-pheno: logical axioms whose subject is a disease and whose object is a phenotype
* axioms_variant-disease: logical axioms whose subject is a gene variant and whose object is a disease or a group of disease
* axioms_icf-procedure: logical axioms whose subject is a body function or an activity and whose object is an evaluation procedure
* axioms_pheno-activity: logical axioms whose subject is a phenotype and whose object is an activity
* axioms_pheno-bf: logical axioms whose subject is a phenotype and whose object is a body function
* axioms_pheno-procedure: logical axioms whose subject is a phenotype and whose object is an evaluation procedure
* axioms_statements: logical axioms whose subject is a statement

### 3. SCRIPTS ###

(Work in progress)

diseases_codes: diseases codes used for the project
genes_names: genes used for the project
