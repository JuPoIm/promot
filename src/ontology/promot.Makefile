## Customize Makefile settings for promot
## Personalisez le Makefile pour promot
## Personalizar el Makefile por promot
# ------------------ EN ----------------------
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile
# ------------------ FR ----------------------
## Si vous devez personnaliser le Makefile, 
## faites-le ici et non dans le fichier Makefile
# ------------------ ES ----------------------
## Si debe personalizar el Makefile, 
## hágalo aquí y no en el Makefile

## Creator name: J. POTIER
## Creator orcid: 0009-0000-5160-7927

## ---------------------------------------------------------
## FILE STRUCTURE - structure du fichier
## ---------------------------------------------------------
# 1 - CUSTOM VARIABLES - variables personnalisées
# 2 - CUSTOM IMPORTS - imports personalisés
# 3 - CUSTOM COMMANDS & SCRIPTS - commandes et scripts personalisés
## ---------------------------------------------------------

## -------------------------------------------------------------------------------
## 1 - CUSTOM VARIABLES - variables personalisées
## -------------------------------------------------------------------------------
IMPORTSDATADIR =  ../data/imports
PROMOTDATADIR = ../data/promot
SCRIPTSDATADIR = ../data/scripts
METADATADIR = ../metadata
PYTHONTMPDIR = ../scripts/python/tmp
ICF = true

## -------------------------------------------------------------------------------
## 2 - CUSTOM IMPORTS - imports personalisés
## -------------------------------------------------------------------------------
# ----------------------------------------
# Module BFO : classes
# ----------------------------------------
$(IMPORTDIR)/bfo_import.owl: $(MIRRORDIR)/bfo.owl $(IMPORTDIR)/bfo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		extract -T $(IMPORTDIR)/bfo_terms.txt --force true --method TOP \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module ECO : classes
# ----------------------------------------
$(IMPORTDIR)/eco_import.owl: $(MIRRORDIR)/eco.owl $(IMPORTDIR)/eco_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/eco_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module FMA : classes
# ----------------------------------------
$(IMPORTDIR)/fma_import.owl: $(MIRRORDIR)/fma.owl $(IMPORTDIR)/fma_terms_alone.txt $(IMPORTDIR)/fma_terms_ancestors.txt $(IMPORTDIR)/fma_exclude_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/fma_terms_ancestors.txt --select "self ancestors annotations" --signature true \
		remove -T $(IMPORTDIR)/fma_exclude_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module HP (EN-FR-ES) : classes
# ----------------------------------------
# Downloading of the French and Spanish translation from github (hp-es.synonyms.owl empty on 08/12/25)
# Merging of the data babelon and synonyms with mirror hp.owl into mirror/hp-merged.owl
# Import of self descendants annotations
# Import of self annotations
# Import of self ancestors annotations
# Merging of the results into imports/hp_import.owl
$(IMPORTDIR)/hp_import.owl: $(MIRRORDIR)/hp.owl $(IMPORTDIR)/hp_terms_descendants.txt $(IMPORTDIR)/hp_terms_alone.txt $(IMPORTDIR)/hp_terms_ancestors.txt
	if [ $(IMP) = true ]; then \
		curl -L https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/refs/heads/master/src/translations/hp-fr.babelon.owl \
		--output $(TMPDIR)/hp-fr.babelon.owl; \
		$(ROBOT) remove $(TMPDIR)/hp-fr.babelon.owl \
		-T $(IMPORTDIR)/hp_fr-bab_exclude_terms.txt --select "self annotations" --signature true \
		--output $(IMPORTSDATADIR)/hp-fr.babelon.owl; \
		curl -L https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/refs/heads/master/src/translations/hp-es.babelon.owl \
		--output $(IMPORTSDATADIR)/hp-es.babelon.owl; \
		curl -L https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/refs/heads/master/src/translations/hp-fr.synonyms.owl \
		--output $(IMPORTSDATADIR)/hp-fr.synonyms.owl;\
		curl -L https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/refs/heads/master/src/translations/hp-es.synonyms.owl \
		--output $(IMPORTSDATADIR)/hp-es.synonyms.owl;\
		$(ROBOT) merge -i $< -i $(IMPORTSDATADIR)/hp-fr.babelon.owl -i $(IMPORTSDATADIR)/hp-es.babelon.owl \
		-i $(IMPORTSDATADIR)/hp-fr.synonyms.owl -i $(IMPORTSDATADIR)/hp-es.synonyms.owl \
		--output $(MIRRORDIR)/hp-merged.owl; \
		$(ROBOT) query -i $(MIRRORDIR)/hp-merged.owl --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/hp_terms_descendants.txt \
		--select "self descendants annotations" --signature true \
		--output $@.tmp.owl ; \
		$(ROBOT) filter -i $(MIRRORDIR)/hp-merged.owl -T $(IMPORTDIR)/hp_terms_alone.txt \
		--select "self annotations" --signature true \
		merge -i $@.tmp.owl --output $@.tmp.owl ; \
		$(ROBOT) filter -i $(MIRRORDIR)/hp-merged.owl -T $(IMPORTDIR)/hp_terms_ancestors.txt \
		--select "self ancestors annotations" --signature true \
		remove -T $(IMPORTDIR)/hp_exclude_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module NCIT : classes
# ----------------------------------------
imports/ncit_import.owl: $(MIRRORDIR)/ncit.owl $(IMPORTDIR)/ncit_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/ncit_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module ORDO : classes
# ----------------------------------------
imports/ordo_import.owl: $(MIRRORDIR)/ordo.owl $(IMPORTDIR)/ordo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/ordo_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module RO : object properties
# ----------------------------------------
$(IMPORTDIR)/ro_import.owl: $(MIRRORDIR)/ro.owl $(IMPORTDIR)/ro_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/ro_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module SNOMED : classes
# ----------------------------------------
# REQUIREMENTS
# 1. Create an account and get a UMLS licence on https://www.nlm.nih.gov/healthit/snomedct/international.html 
# 2. Download the latest SNOMED CT international edition (RF2 files) from https://www.nlm.nih.gov/healthit/snomedct/international.html 
# 3. Download the latest SNOMED CT Spanish (castellano) edition from https://www.nlm.nih.gov/healthit/snomedct/international.html
# 4. Add the Spanish (castellano) files to the SNOMED CT international.zip (if needed, create a new .zip such as 'SNOMEDCT_en-es' to combine them)
# 5. Convert RF2 files to owl with https://github.com/IHTSDO/snomed-owl-toolkit/releases
# 6. Put the resulting 'ontology-YYYY-MM-DD_EN-ES.owl' in ../data/
# 7. Create an account and get an licence on https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
# 8. Download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
# 9. Put 'terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl' in ../data/
# 10. Use hereafter code
# OR
# 8. Download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
# 9. Same process than 1. to 5. with french files added in .zip at stage 3.
# 10. Custom hereafter code to fit your choice
# OR
# 7. Same process than 1. to 8.
# 8. Merge the .owl resulting from 4. with terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl (French edition)
# 9. Put the resulting .owl in ../data/
# 10. Custom hereafter code to fit your choice
$(IMPORTDIR)/snomed_import.owl: $(IMPORTSDATADIR)/ontology-2025-11-14_EN-ES.owl $(IMPORTSDATADIR)/SnomedCT_NationalFR_OWL.owl $(IMPORTDIR)/snomed_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/snomed_terms.txt --select "annotations self" --signature true \
		query --update $(SPARQLDIR)/delete_label.sparql \
		rename --mapping skos:prefLabel rdfs:label \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl ; \
		$(ROBOT) query -i $(IMPORTSDATADIR)/SnomedCT_NationalFR_OWL.owl --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/snomed_terms.txt --select "annotations self" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		remove --select "annotations='http://data.esante.gouv.fr/NRC-France/sct-ext#fsn'" \
  		--select "annotations='http://data.esante.gouv.fr/NRC-France/sct-ext#definitionStatus'" \
		--select "annotations='http://purl.org/dc/elements/1.1/type'" \
		--select "annotations='http://www.w3.org/2004/02/skos/core#notation'" \
		--output $@.tmp.owl && mv $@.tmp.owl $@ ; fi

# ----------------------------------------
# Module ICF (EN):
# ----------------------------------------
# WHAT'S DONE 
# 1. Download file from https://github.com/whoficitc/harmonization/blob/main/ontology/whofic-2025-05-24.owl
# 2. Put it in /IMPORTSDATADIR/
# A. extraction des termes avec enfants avec filter
# B. extratcion des termes avec ancêtres en excluant certains terms avec filter et remove
# C. merge des fichiers
# D. rename des préfixes skos pour passer les tests de la release
$(IMPORTDIR)/icf_import.owl: $(IMPORTSDATADIR)/whofic-2025-05-24.owl $(IMPORTDIR)/icf_terms_descendants.txt $(IMPORTDIR)/icf_terms.txt $(IMPORTDIR)/icf_exclude_terms.txt
	if [ $(IMP) = true ] && [ $(ICF) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/icf_terms_descendants.txt \
		--select "self descendants annotations" \
		--exclude-term http://id.who.int/icd/entity/721275161 \
		--signature true \
		--output $@.tmp.owl; \
		$(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/icf_terms.txt \
		--select "self ancestors annotations" \
		--exclude-terms $(IMPORTDIR)/icf_exclude_terms.txt \
		--signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		rename --add-prefix "rdfs: http://www.w3.org/2000/01/rdf-schema#" \
		--mapping skos:prefLabel rdfs:label \
		rename --add-prefix "IAO: http://purl.obolibrary.org/obo/IAO_" \
		--mapping skos:definition IAO:0000115 \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi


## -------------------------------------------------------------------------------------------------
## 2 - CUSTOM COMMANDS & SCRIPTS EXECUTION - commandes personalisées et exécution des scripts python
## -------------------------------------------------------------------------------------------------

## -------------------
## BY EXECUTION ORDER
## -------------------

# ----------------------------------------
# UNDER DEVELOPMENT
# Extract phenotypes associated with a gene and a disease in HPO
# Extraction des phénotypes associés en même temps à un gène et une maladie du projet dans HPO
# ----------------------------------------
.PHONY: extract-pheno
extract-pheno:
	curl -L https://github.com/obophenotype/human-phenotype-ontology/releases/download/v2025-10-22/genes_to_phenotype.txt \
	-o $(SCRIPTSDATADIR)/genes_to_phenotype.txt
	python3.12 $(SCRIPTSDIR)/python/GenesToPhenos.py


# ---------------------------------------------
# ICF Translations - Traductions - Traducciones
# ---------------------------------------------
# process 'CIF - ASIP' ontology and 2026 ICF translations to map it to ICF by creating an SSSOM file
# mapping automatiques des URIs ICF 2026 et CIF-ASIP 2020 via code ICF, création du fichier SSSOM
# ------------------ FR ----------------------
# 1. téléchargement de CIF-ASIP 2020
# 2. export des données intéressantes en csv (URIs, codes, labels)
# 3. téléchargement des traductions officielles des labels pour ICF 2025
# 4. export des IRI depuis icf_import pour filtrer les mappings pour le sssom du projet en 5.
# 5. exécution du script de mapping via les codes ICF
# 6. création du SSSOM pour les deux fichiers créés par le script python : un avec les codes utilisés par PROMOT et un avec tous les codes ICF mappés aux codes CIF-ASIP
# ------------------ EN ----------------------
# 1. download of 2020 CIF-ASIP
# 2. csv export of interesting CIF-ASIP data (URIs, codes, labels)
# 3. download of translated labels with codes from 2025 ICF browser
# 4. csv export of IRIs belonging to icf_import (to create a mapping file with ICF URIs used in PROMOT only)
# 5. python script that creates 2 files : one with the overall ICF-CIF mapping and a second with ICF URIs used in PROMOT only
# 6. creates two SSSOM files for the two herebefore files
# ----------------------------------------
.PHONY: translation-icf
translation-icf: refresh-icf $(IMPORTDIR)/icf_import.owl
	if [ $(ICF) = true ]; then \
	curl -L https://data.bioportal.lirmm.fr/ontologies/ICF/submissions/2/download?apikey=1de0a270-29c5-4dda-b043-7c3580628cd5 -o $(IMPORTSDATADIR)/cif-asip.ttl ; \
	$(ROBOT) --prefix "skos: http://www.w3.org/2004/02/skos/core#" --prefix "rdfs: http://www.w3.org/2000/01/rdf-schema#" -vvv export -i $(IMPORTSDATADIR)/cif-asip.ttl --header "IRI|skos:notation|skos:altLabel" --export $(PYTHONTMPDIR)/CIF-ASIP.tsv ; \
	$(ROBOT) convert --input $(IMPORTSDATADIR)/cif-asip.ttl --output $(MIRRORDIR)/cif-asip.owl ; \
	curl -L "https://icdcdn.who.int/static/releasefiles/2026-01/SimpleTabulation-ICF-fr.zip" -o $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr.zip ; \
	unzip -q $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr.zip -d $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr/ ; \
	mv $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr/SimpleTabulation-ICF-fr.txt $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr.txt ; \
	rm $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr.zip ; \
	rm -r $(IMPORTSDATADIR)/SimpleTabulation-ICF-fr/ ; \
	curl -L "https://icdcdn.who.int/static/releasefiles/2026-01/SimpleTabulation-ICF-es.zip" -o $(IMPORTSDATADIR)/SimpleTabulation-ICF-es.zip ; \
	unzip -q $(IMPORTSDATADIR)/SimpleTabulation-ICF-es.zip -d $(IMPORTSDATADIR)/SimpleTabulation-ICF-es/ ; \
	mv $(IMPORTSDATADIR)/SimpleTabulation-ICF-es/SimpleTabulation-ICF-es.txt $(IMPORTSDATADIR)/SimpleTabulation-ICF-es.txt ; \
	rm $(IMPORTSDATADIR)/SimpleTabulation-ICF-es.zip ; \
	rm -r $(IMPORTSDATADIR)/SimpleTabulation-ICF-es/ ; \
	$(ROBOT) export -i $(IMPORTDIR)/icf_import.owl --header "IRI" --export $(PYTHONTMPDIR)/icf_import_iri.tsv ; \
	python3.12 $(SCRIPTSDIR)/python/CIFASIP-ICF_mapping.py $(VERSION) ; \
	python3.12 $(SCRIPTSDIR)/python/ICF_labels-es-fr.py ; \
	$(SSSOMPY) parse -m $(METADATADIR)/mapping-all.yml -o $(MAPPINGDIR)/icf-to-cif_all-mappings.sssom.tsv $(PYTHONTMPDIR)/icf-to-cifasip_all.tsv ; \
	$(SSSOMPY) parse -m $(METADATADIR)/mapping-promot.yml -o $(MAPPINGDIR)/icf-to-cif_promot-mappings.sssom.tsv $(PYTHONTMPDIR)/icf-to-cifasip_promot.tsv ; fi
#	$(ROBOT) -vvv query -i $(MIRRORDIR)/cif-asip.owl --update $(SPARQLDIR)/preprocess-module.ru filter -T $(IMPORTDIR)/cifasip_terms.txt \
#	--select "self annotations" --signature true --output $(IMPORTDIR)/cif-asip_import.owl; \
#	$(ROBOT) query -i $(IMPORTDIR)/cif-asip_import.owl --update $(SPARQLDIR)/preprocess-module.ru \
#    query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
#	annotate --ontology-iri $(IMPORTDIR)/cif-asip_import.owl $(ANNOTATE_ONTOLOGY_VERSION) \
#	merge -i $(IMPORTDIR)/cif-asip_import.owl --output $(IMPORTDIR)/cif-asip_import.owl && mv $(IMPORTDIR)/cif-asip_import.owl $@; fi


# ----------------------------------------
# CREATE THE ROBOT TEMPLATE FOR PROMOT-COMPONENT.OWL
# BY COMBINING A BASE TEMPLATE WITH THE RELATIONS TEMPLATE AND THE TRANSLATIONS TEMPLATE 
# TO EXECUTE BEFORE EXECUTING recreate-components
#  - NEED 1 promot-component-base.tsv ROBOT template in promot/src/templates/ (hand edited)
#  - NEED 1 RELATIONS.TSV DATA FILE in promot/src/data/promot/ (hand edited)
#  - NEED translation-icf TO BE EXECUTED FIRST to have the ROBOT template icf_labels-es-fr.tsv in promot/src/templates/
# OUTPUT promot-component.tsv in promot/src/templates/ that would be transformed into promot/components/promot-component.owl
# ----------------------------------------
.PHONY: create-template
create-template: translation-icf $(TEMPLATEDIR)/promot-component-base.tsv $(TEMPLATEDIR)/icf_labels_es-fr.tsv $(PROMOTDATADIR)/*.tsv
	python3.12 $(SCRIPTSDIR)/python/relations-to-template.py

# ----------------------------------------
# CREDITS
# ----------------------------------------
# add credits to promot-edit.owl and delete root node
credits: credits.ttl
	$(ROBOT) annotate --input $(ONT)-edit.owl --annotation-file credits.ttl --output $(ONT)-edit.owl
	$(ROBOT) remove --input $(ONT)-edit.owl --term PROMOT:0000000 --signature true --output $(ONT)-edit.owl

# ----------------------------------------
# CUSTOM RECREATE-COMPONENT
# ----------------------------------------
$(COMPONENTSDIR)/promot-component.owl: credits create-template $(TEMPLATEDIR)/promot-component-auto.tsv $(TMPDIR)/stamp-component-promot-component.owl
	$(ROBOT) template --add-prefixes config/context.json \
		 --template $(TEMPLATEDIR)/promot-component-auto.tsv \
		 $(ANNOTATE_CONVERT_FILE)
.PRECIOUS: $(COMPONENTSDIR)/promot-component.owl

# ----------------------------------------
# Documentation - Documentación
# ----------------------------------------
documentation:
  documentation_system: mkdocs

# ----------------------------------------
# CUSTOM REASON_TEST - reason_test personnalisé pour avoir les logs sur les classes qui ne sont pas satisfaisante
# ----------------------------------------
.PHONY: reason_test
reason_test: $(EDIT_PREPROCESSED) explain_unsat
	$(ROBOT) reason --input $< --reasoner $(REASONER) --equivalent-classes-allowed asserted-only \
		--exclude-tautologies structural --output test.owl && rm test.owl