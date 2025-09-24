## Customize Makefile settings for promot
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile
#
# BFO : classes and object properties
imports/bfo_import.owl: mirror/bfo.owl imports/bfo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T imports/bfo_terms_combined.txt --force true --method TOP \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# ECO : classes
imports/eco_import.owl: mirror/eco.owl imports/eco_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/eco_terms.txt --select "self annotations" --exclude-terms imports/eco_terms.txt --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# MONDO : classes
imports/mondo_import.owl: mirror/mondo.owl imports/mondo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/mondo_terms.txt --select "self annotations" --exclude-terms imports/hp_terms.txt --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# FMA : classes
imports/fma_import.owl: mirror/fma.owl imports/fma_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/fma_terms.txt \
        --select "self descendants annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/fma_terms_alone.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# HP : classes 
imports/hp_import.owl: mirror/hp.owl imports/hp_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_descendants.txt \
        --select "self descendants annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_alone.txt \
        --select "self annotations" --signature true \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/hp_terms_ancestors.txt --select "self ancestors annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# HP FR : classes 
imports/hp-fr_import.owl: mirror/hp-fr.owl imports/hp_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_descendants.txt \
        --select "self descendants annotations" --signature true \
		--drop-axiom-annotations rdfs:comment \
		--drop-axiom-annotations oboInOwl:id \
		--drop-axiom-annotations oboInOwl:hasAlternativeId \
		--drop-axiom-annotations obo:IAO_0000115 \
		--drop-axiom-annotations oboInOwl:hasExactSynonym \
		--drop-axiom-annotations oboInOwl:hasDbXref \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_alone.txt \
        --select "self annotations" --signature true \
		--drop-axiom-annotations rdfs:comment \
		--drop-axiom-annotations oboInOwl:id \
		--drop-axiom-annotations oboInOwl:hasAlternativeId \
		--drop-axiom-annotations obo:IAO_0000115 \
		--drop-axiom-annotations oboInOwl:hasExactSynonym \
		--drop-axiom-annotations oboInOwl:hasDbXref \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/hp_terms_ancestors.txt --select "self ancestors annotations" --signature true \
		--drop-axiom-annotations rdfs:comment \
		--drop-axiom-annotations oboInOwl:id \
		--drop-axiom-annotations oboInOwl:hasAlternativeId \
		--drop-axiom-annotations obo:IAO_0000115 \
		--drop-axiom-annotations oboInOwl:hasExactSynonym \
		--drop-axiom-annotations oboInOwl:hasDbXref \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# HP : classes 
imports/hp-es_import.owl: mirror/hp-international.owl imports/hp_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_descendants.txt \
		--select "rdfs:label=@es" \
		--select "dc:date" \
		--select "dcterms:creator" \
		--select "rdfs:comment" \
		--select "obo:IAO:0000115=@es" \
        --select "self descendants" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/hp_terms_alone.txt \
		--select "rdfs:label=@es" \
		--select "dc:date" \
		--select "dcterms:creator" \
		--select "rdfs:comment" \
		--select "obo:IAO:0000115=@es" \
        --select "self" --signature true \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/hp_terms_ancestors.txt --select "rdfs:label=@es" --select "dc:date" --select "dcterms:creator" --select "rdfs:comment" --select "obo:IAO:0000115=@es" --select "self ancestors" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# RO
imports/ro_import.owl: mirror/ro.owl imports/ro_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/ro_terms.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# WHOFIC
imports/whofic_import.owl: mirror/whofic-2024-01-21.owl imports/whofic_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/whofic_terms_descendants.txt \
        --select "self descendants annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/whofic_terms.txt --select "self ancestors annotations" --signature true \
		remove -T imports/whofic_exclude_terms.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# SCDO : object property 'measures'
imports/scdo_import.owl: mirror/scdo.owl imports/scdo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/scdo_terms.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# SIO
imports/sio_import.owl: mirror/sio.owl imports/sio_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/sio_terms_alone.txt \
        --select "self annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/sio_terms.txt --select "self descendants annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# SNOMED
imports/snomed_import.owl: mirror/snomed.owl imports/snomed_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/snomed_terms_alone.txt \
        --select "self annotations" --signature true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/snomed_terms_descendants.txt --select "self descendants annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
# VO
imports/vo_import.owl: mirror/vo.owl imports/vo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/vo_terms.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# OBI : 2 classes
imports/obi_import.owl: mirror/obi.owl imports/obi_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		filter -T imports/obi_terms.txt --select "self annotations" --signature true \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
# DOCUMENTATION
documentation:
  documentation_system: mkdocs