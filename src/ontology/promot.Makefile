## Customize Makefile settings for promot
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile
#
# BFO
imports/bfo_import.owl: mirror/bfo.owl imports/bfo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T imports/bfo_terms_combined.txt --force true --individuals exclude --method TOP \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# MONDO
imports/mondo_import.owl: mirror/mondo.owl imports/mondo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/mondo_terms_combined.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# FMA
imports/fma_import.owl: mirror/fma.owl imports/fma_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/fma_terms_combined.txt --select "self descendants annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# HP
imports/hp_import.owl: mirror/hp.owl imports/hp_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/hp_terms_combined.txt --select "self ancestors annotations" --signature true \
        collapse --threshold 2 \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# RO
imports/ro_import.owl: mirror/ro.owl imports/ro_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/ro_terms_combined.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# WHOFIC
imports/whofic_import.owl: mirror/whofic.owl imports/whofic_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/whofic_terms_combined.txt --select "self ancestors annotations" --signature true \
        collapse --threshold 2 \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# SNOMED
imports/snomed_import.owl: mirror/snomed.owl imports/snomed_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/snomed_terms_combined.txt --select "self ancestors annotations" --signature true \
        collapse --threshold 2 \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi