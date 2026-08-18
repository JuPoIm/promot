# Ontology description
[//]: # "This file is meant to be edited by the ontology maintainer."

## Diseases described
* [Oculopharyngeal Muscular Dystrophy](https://www.orpha.net/en/disease/detail/270?name=Oculopharyngeal%20Muscular%20Dystrophy&mode=name) (OPMD)
* [Congenital Myasthenic Syndromes](https://www.orpha.net/en/disease/detail/590?name=Congenital%20myasthenic%20syndromes&mode=name) (CMS)
* [Congenital Myopathies](https://www.orpha.net/en/disease/detail/97245?name=Congenital%20Myopathy&mode=name) (CMYO)

## Imported upper-ontology:
* [Basic Formal Ontology](https://github.com/BFO-ontology) (BFO)

## Imported ontologies:
* [Evidence and Conclusion Ontology](https://obofoundry.org/ontology/eco.html) (ECO)
* [Foundational Model of Anatomy](https://bioportal.bioontology.org/ontologies/FMA) (FMA)
* [Human Phenotype Ontology](https://github.com/obophenotype/human-phenotype-ontology) (HPO)
* [Information Artifact Ontology](https://obofoundry.org/ontology/iao.html) (IAO)
* [Ontology for Biomedical Investigations](https://github.com/obi-ontology/obi) (OBI)
* [Orphanet Rare Disease Ontology](https://bioportal.bioontology.org/ontologies/ORDO) (ORDO)
* [Relation Ontology](https://obofoundry.org/ontology/ro.html) (RO)
* [Sequence types and features ontology](https://obofoundry.org/ontology/so.html) (SO)

## Imported classifications:
* [SNOMED Clinical Terminology](https://www.snomed.org/)
* [International Classification of Functioning, Disability and Health](https://icd.who.int/browse/2026-01/icf/en) (ICF)
* [National Cancer Institute Thesaurus](https://bioportal.bioontology.org/ontologies/NCIT) (NCIT)

## Ontology schema
(Upcoming)

## Statistics
(Upcoming)

### BFO classes
(Upcoming)

### Number of entities
(Upcoming)

Qualifiers
We rely on the ‘Anatomical localization’ qualifier provided by ICF to describe  the localization of anatomical entities and body structures related to phenotypes, and some clinical modifiers from HPO to describe the clinical course of phenotypes such as the onset, the severity or the pace of progression. We also kept HPO:0012824 ‘Severity’ to clarify the severity of each phenotype instance. We used SIO ‘biological quality’ to describe the transmission of gene mutation and to describe the life status of each individual (patients and relatives).
All qualifiers are classified under BFO ‘quality’.

QUALITY ABOUT
LABEL
IRI USED IN PROMOT
Xcdm
PHENOTYPE
Presence qualifier
PROMOT:0031007


PHENOTYPE
Onset
HP:0003674
RDCDM
PHENOTYPE
Severity
HP:0012824
RDCDM
PHENOTYPE
Pace of progression
HP:0003679


HUMAN
Vital status
NCIT:C25717
ERDRI, PhenoPackets
MUTATION
variant_origin
SO:0001762


ANATOMICAL ENTITY
Anatomical localization
ICF:437219407


BODY STRUCTURE
Anatomical localization
ICF:437219407


Onset (HP:0003674) - 22 sub-qualifiers
Congenital onset (HP:0003577)
Adult onset (HP:0003581)
Late onset (HP:0003584)
Middle age onset (HP:0003596)
Young adult onset (HP:0011462)
Early young adult onset (HP:0025708)
Intermediate young adult onset (HP:0025709)
Late young adult onset (HP:0025710)
Neonatal onset (HP:0003623)
Antenatal onset (HP:0030674)
Embryonal onset (HP:0011460)
Fetal onset (HP:0011461)
Third trimester onset (HP:0034197)
Second trimester onset (HP:0034198)
Late first trimester onset (HP:0034199)
Pediatric onset (HP:0410280)
Infantile onset (HP:0003593)
Juvenile onset (HP:0003621)
Childhood onset (HP:0011463)
Puerpural onset (HP:4000040)
Perimenopausal onset (HP:6000314)
Postmenopausal onset (HP:6000315)


presence qualifier - 4 sub-qualifiers
absent
present
unsure
presence unrecorded


Anatomical localization - 10 sub-qualifiers
distal
proximal
left
right
both sides
front
back
more than one region
not specified
not applicable


Severity (HP:0012824) - 5 sub-qualifiers
Mild (HP:0012825)
Moderate (HP:0012826)
Borderline (HP:0012827)
Severe (HP:0012828)
Profound (HP:0012829)


Pace of progression (HP:0003679) - 5 sub-qualifiers
Progressive (HP:0003676)
Slowly progressive (HP:0003677)
Rapidly progressive (HP:0003678)
Variable progression rate (HP:0003682)
Nonprogressive (HP:0003680)


Vitalstatus (NCIT:C25717) - 6 sub-qualifiers
alive (NCIT:C37987)


Found Dead (NCIT:C90387)
unkown vital status (PROMOT:0031001)
Unrecorded vital status (PROMOT:0031002)
lost in follow-up (PROMOT:0031003)
Opted-out (PROMOT:0031004)
Variant_origin (SO:0001762) - 5 sub-qualifiers
maternal variant (SO:0001775)
paternal variant (SO:0001776)
De novo variant (SO:0001781)
variant origin unknown (PROMOT:0031005)
variant origin unrecorded (PROMOT:0031006)

### Number of relations
(Upcoming)

Relations

Table x. Object properties
Object properties prefix
Source Ontology Name
Nb of object properties
ro
Relations Ontology
9
promot
PROMOT Ontology
4


Table x. Relations
Subject/Domain


Predicate label
Predicate IRI
Object/Range
Nb of logical axioms
Variant


is causal germline mutation in
RO:0004013
Disease
1
Disease


has material basis in germline mutation in
RO:0004003
Variant
1
Disease


disease has feature
RO:0004029
Phenotypic Abnormality
362
Phenotypic abnormality


Phenotype of


Patient
1
Patient


Has gene mutation


Variant
1
PR Anatomical entity


Has disposition
RO:0000091
Phenotypic abnormality
42
Anatomical entity


Located in
RO:0001025
Body structure
24
PR Body structure


Has disposition
RO:0000091
Phenotypic abnormality
48
Body structure


Functionally related to


Body function
7
APR Body structure


Involved in(to replace PROMOT affects)


Activities or participation
2
APR Body function


Involved in(to replace PROMOT affects)


Activities or participation


PR Body function


Is related to


Phenotypic abnormality
60
Procedure by method


Assesses
PROMOT:2000002
Patient
1
Procedure by method


Measures
PROMOT:2000003
BS/BF/AP


Procedure by method


Has output


Observable entity


Procedure by method


Brings out


Phenotypic abnormality
216
Procedure by method


Assesses


Activities or participation


Statement


Has member


Observable entity/Human/Phenotypic abnormality/Procedure


RELATIONS
Due to redundant declarations, XX explicit relations were removed from the main ontology release by the reasoner. They are inferrable thanks to the lowest level relations and therefore kept implicit. For documentation and future development purposes (e.g. if some phenotypes are removed at some point) a version of the ontology maintaining the redundancy is also accessible aside the official release (‘promot-non-classified’).


### Translations rate
(Work in progress)

SNOMED CT Spanish translations include terms in Castellano.

Table: Translation rate for labels in PROMOT ontology

----------------------------------------------------
prefix|Source Ontology Name|English|Spanish|French
----------------------------------------------------
hpo|Human Phenotype Ontology|100%|100%|89%
icf|International Classification of Functioning, Disability and Health|100%|95%\*|95%\*
snomed|Systematized Nomenclature of Medicine - Clinical Terms|100%|100%|100%
promot|PROMOT ontology|100%||
all prefixes|All ontologies in PROMOT ontology|100%|83%|78%

* ICF does not provide a translation for the qualifier ‘anatomical localization’ and its subcategories.

## Cross references and Mappings
When a class included in PROMOT ontology overlaps an element from one of these initiatives, we provided a note quoting the original initiative. In the case of the original element being associated with an IRI, and if the IRI of the class included in PROMOT is different, we created a cross reference toward the IRI of the original element and a mapping file following the SSSOM rules (ref ?). 
We implemented  ontology mappings following the Simple Standard for Sharing Ontology Mappings [41] that links ICF classes to corresponding CIF-ASIP classes, including their Spanish and French translations provided by the LIRMM (ref ICF Asip).
We also provided SSSOM mappings that link our PROMOT specific classes to their equivalent in SNOMED [26,27], BIOLINK [42] or NCIT.

### A trier



