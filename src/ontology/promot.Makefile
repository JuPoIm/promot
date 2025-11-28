## Customize Makefile settings for promot
## 
# ------------------ EN ----------------------
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile
# ------------------ FR ----------------------
## Si vous devez personnaliser le Makefile, 
## faites-le ici et non dans le fichier Makefile
# ------------------ ES ----------------------
## Si debe personalizar el Makefile, 
## hágalo aquí y no en el Makefile

DATADIR =  ../data
METADATADIR = ../metadata
SCRIPTS_DATA =  ../scripts/python/data

# ----------------------------------------
# Module BFO : classes and object properties
# ----------------------------------------
$(IMPORTDIR)/bfo_import.owl: $(MIRRORDIR)/bfo.owl $(IMPORTDIR)/bfo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		extract -T $(IMPORTDIR)/bfo_terms_combined.txt --force true --method TOP \
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
# Module MONDO : classes
# ----------------------------------------
imports/mondo_import.owl: $(MIRRORDIR)/mondo.owl $(IMPORTDIR)/mondo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/mondo_terms.txt --select "self annotations" --exclude-terms $(IMPORTDIR)/hp_terms.txt --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module FMA : classes
# ----------------------------------------
$(IMPORTDIR)/fma_import.owl: $(MIRRORDIR)/fma.owl $(IMPORTDIR)/fma_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -i $< -T $(IMPORTDIR)/fma_terms.txt \
        --select "self descendants annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/fma_terms_alone.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module HP EN : classes
# ----------------------------------------
$(IMPORTDIR)/hp_import.owl: $(MIRRORDIR)/hp.owl $(IMPORTDIR)/hp_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/hp_terms_descendants.txt \
        --select "self descendants annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_alone.txt \
        --select "self annotations" --signature true \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/hp_terms_ancestors.txt --select "self ancestors annotations" --signature true \
		remove -T $(IMPORTDIR)/hp_exclude_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module RO
# ----------------------------------------
$(IMPORTDIR)/ro_import.owl: $(MIRRORDIR)/ro.owl $(IMPORTDIR)/ro_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/ro_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module WHOFIC EN : no-mirror-refresh
# ----------------------------------------
# 1. extraction des termes avec enfants avec filter
# 2. extratcion des termes avec ancêtres en excluant certains terms avec filter et remove
# 3. merge des fichiers
# 4. rename des préfixes skos pour passer les tests de la release
$(IMPORTDIR)/whofic_import.owl: $(MIRRORDIR)/whofic-2025-05-24.owl $(IMPORTDIR)/whofic_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/whofic_terms_descendants.txt \
        --select "self descendants annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/whofic_terms.txt --select "self ancestors annotations" --signature true \
		remove -T $(IMPORTDIR)/whofic_exclude_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		rename --add-prefix "rdfs: http://www.w3.org/2000/01/rdf-schema#" \
		--mapping skos:prefLabel rdfs:label \
		rename --add-prefix "IAO: http://purl.obolibrary.org/obo/IAO_" \
		--mapping skos:definition IAO:0000115 \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------		
# Module SCDO : object property 'measures'
# ----------------------------------------
$(IMPORTDIR)/scdo_import.owl: $(MIRRORDIR)/scdo.owl $(IMPORTDIR)/scdo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/scdo_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module SIO : no-mirror-refresh
# ----------------------------------------
$(IMPORTDIR)/sio_import.owl: $(MIRRORDIR)/sio-release.owl $(IMPORTDIR)/sio_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -i $< -T $(IMPORTDIR)/sio_terms_alone.txt \
        --select "self annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/sio_terms.txt --select "self descendants annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module SNOMED : no-mirror-refresh
# ----------------------------------------
# 1. Download the latest SNOMED CT international edition (RF2 files) from https://www.nlm.nih.gov/healthit/snomedct/international.html
# 2. Download the latest SNOMED CT Spanish (castellano) edition from https://www.nlm.nih.gov/healthit/snomedct/international.html
# 3. Download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
# 4. Merge the Spanish (castellano) and French files to the SNOMED CT international .zip (or create a new .zip such as 'SNOMEDCT_en-es-fr' if need to combine them)
# 5. Convert RF2 files to owl with https://github.com/IHTSDO/snomed-owl-toolkit/releases
# 6. Put the resulting snomed.owl in ../data/
## Note that you can also merge the terminologie-snomed-ct-fr/dat/SnomedCT-NationalFR_OWL_asserted_20250621.owl (French edition) to the .owl merging international and Spanish version 
$(IMPORTDIR)/snomed_import.owl: $(DATADIR)/ontology-2025-11-14_EN-ES.owl
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/snomed_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module SNOMED FR : no-mirror-refresh
# ----------------------------------------
# Download the latest SNOMED CT French edition from https://smt.esante.gouv.fr/terminologie-snomed-ct-fr/
# Use the owl version in the /terminologie-snomed-ct-fr/dat/ and put it in ../data/
# OR 
# Convert RF2 files in /terminologie-snomed-ct-fr/src/ to owl with https://github.com/IHTSDO/snomed-owl-toolkit/releases
# and put the resulting .owl in ../data/
$(IMPORTDIR)/snomed-fr_import.owl: $(DATADIR)/SnomedCT_NationalFR_OWL.owl
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/snomed_terms.txt --select "self annotations" --signature true \
		query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module VO 
# ----------------------------------------
$(IMPORTDIR)/vo_import.owl: $(MIRRORDIR)/vo.owl $(IMPORTDIR)/vo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/vo_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module OBI : 2 classes
# ----------------------------------------
$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/obi_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module BIOLINK
# ----------------------------------------
$(IMPORTDIR)/biolink_import.owl: $(MIRRORDIR)/biolink-model.xrdf $(IMPORTDIR)/biolink_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update $(SPARQLDIR)/preprocess-module.ru \
		filter -T $(IMPORTDIR)/biolink_terms.txt --select "self annotations" --signature true \
        query --update $(SPARQLDIR)/inject-subset-declaration.ru --update $(SPARQLDIR)/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module HP ES babelon :
# ----------------------------------------
$(IMPORTDIR)/hp-es-bab_import.owl: $(MIRRORDIR)/hp-es-bab.owl
	if [ $(IMP) = true ]; then $(ROBOT) annotate -i $< --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
	--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module HP FR babelon :
# ----------------------------------------
$(IMPORTDIR)/hp-fr-bab_import.owl: $(MIRRORDIR)/hp-fr-bab.owl
	if [ $(IMP) = true ]; then $(ROBOT) annotate -i $< --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
	--output $@.tmp.owl && mv $@.tmp.owl $@; fi

# ----------------------------------------
# Module ORCID
# ----------------------------------------
$(IMPORTDIR)/orcidio_terms_combined.txt: $(SRCMERGED)
	$(ROBOT) query -f csv -i $< --query $(SPARQLDIR)/orcids.sparql $@.tmp && \
	cat $@.tmp | sort | uniq >  $@

# ----------------------------------------
# Documentation / Documentación
# ----------------------------------------
documentation:
  documentation_system: mkdocs

# ----------------------------------------
# Translations / Traductions / Traducciones
# ----------------------------------------
# process 'CIF - ASIP' ontology and 2025 ICF translations to map it to ICF by creating an SSSOM file
# mapping automatiques des URIs ICF 2025 et CIF-ASIP 2020 via code ICF, création du fichier SSSOM
# ------------------ FR ----------------------
# 1. téléchargement de CIF-ASIP 2020
# 2. export des données intéressantes en csv (URIs, codes, labels)
# 3. téléchargement des traductions officielles des labels pour ICF 2025
# 4. export des IRI depuis whofic_import pour filtrer les mappings pour le sssom du projet en 5.
# 5. exécution du script de mapping via les codes ICF
# 6. création du SSSOM pour les deux fichiers créés par le script python : un avec les codes utilisés par PROMOT et un avec tous les codes ICF mappés aux codes CIF-ASIP
# ------------------ EN ----------------------
# 1. download of CIF-ASIP 2020
# 2. csv export of interesting CIF-ASIP data (URIs, codes, labels)
# 3. download of translated labels with codes from 2025 ICF browser
# 4. csv export of IRIs belonging to whofic_import (to create a mapping file with ICF URIs used in PROMOT only)
# 5. python script that creates 2 files : one with the overall ICF-CIF mapping and a second with ICF URIs used in PROMOT only
# 6. creates two SSSOM files for the two herebefore files
# ----------------------------------------
.PHONY: translation-mapping-ICF
translation-mapping-ICF:
	curl -L https://data.bioportal.lirmm.fr/ontologies/ICF/submissions/2/download?apikey=1de0a270-29c5-4dda-b043-7c3580628cd5 -o $(DATADIR)/cif-asip.ttl
	$(ROBOT) --prefix "skos: http://www.w3.org/2004/02/skos/core#" --prefix "rdfs: http://www.w3.org/2000/01/rdf-schema#" -vvv export -i $(DATADIR)/cif-asip.ttl --header "IRI|skos:notation|skos:altLabel" --export $(SCRIPTS_DATA)/CIF-ASIP.tsv
	curl -L "https://icdcdn.who.int/static/releasefiles/2025-01/SimpleTabulation-ICF-fr.zip" -o $(SCRIPTS_DATA)/SimpleTabulation-ICF-fr.zip
	unzip -q $(SCRIPTS_DATA)/SimpleTabulation-ICF-fr.zip -d $(SCRIPTS_DATA)/SimpleTabulation-ICF-fr/
	mv $(SCRIPTS_DATA)/SimpleTabulation-ICF-fr/SimpleTabulation-ICF-fr.txt $(DATADIR)/SimpleTabulation-ICF-fr.txt
	rm $(SCRIPTS_DATA)/SimpleTabulation-ICF-fr.zip
	rm -r $(SCRIPTS_DATA)/SimpleTabulation-ICF-fr/
	curl -L "https://icdcdn.who.int/static/releasefiles/2025-01/SimpleTabulation-ICF-es.zip" -o $(SCRIPTS_DATA)/SimpleTabulation-ICF-es.zip
	unzip -q $(SCRIPTS_DATA)/SimpleTabulation-ICF-es.zip -d $(SCRIPTS_DATA)/SimpleTabulation-ICF-es/
	mv $(SCRIPTS_DATA)/SimpleTabulation-ICF-es/SimpleTabulation-ICF-es.txt $(DATADIR)/SimpleTabulation-ICF-es.txt
	rm $(SCRIPTS_DATA)/SimpleTabulation-ICF-es.zip
	rm -r $(SCRIPTS_DATA)/SimpleTabulation-ICF-es/
	$(ROBOT) export -i $(IMPORTDIR)/whofic_import.owl --header "IRI" --export $(SCRIPTS_DATA)/whofic_import_iri.tsv
	python3.12 $(SCRIPTSDIR)/python/CIF-ICF_mapping.py $(VERSION)
	python3.12 $(SCRIPTSDIR)/python/ICF_labels_es-fr.py
	$(SSSOMPY) parse -m $(METADATADIR)/mapping-all.yml -o $(MAPPINGDIR)/ICF_to_CIF_all-mappings.sssom.tsv $(SCRIPTS_DATA)/ICF_to_CIF-ASIP_all.tsv
	$(SSSOMPY) parse -m $(METADATADIR)/mapping-promot.yml -o $(MAPPINGDIR)/ICF_to_CIF_promot-mappings.sssom.tsv $(SCRIPTS_DATA)/ICF_to_CIF-ASIP_promot.tsv

# ----------------------------------------
# Extract phenotypes associated with a gene and a disease in HPO
# Extraction des phénotypes associés en même temps à un gène et une maladie du projet dans HPO
# ----------------------------------------
.PHONY: extract-pheno
extract-pheno:
	curl -L https://github.com/obophenotype/human-phenotype-ontology/releases/download/v2025-10-22/genes_to_phenotype.txt \
	-o $(SOURCESDIR)/genes_to_phenotype.txt
	python3.12 $(SCRIPTSDIR)/python/Stat_GeneToPheno.py
