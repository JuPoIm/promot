# Ontology development
[//]: # "This file is meant to be edited by the ontology maintainer."

(Work in progress)

## Process

After the selection of the domain specific entities and the relations between them, more detailed entities and relations were defined according to the following process:
Selection of the ontology classes for the domain specific entities:
Selection of phenotypic entities
Starting from the HPO codes selected for the phenotypic abnormalities, their HPO ancestry was imported to PROMOT ontology.
Selection of impairments, body structure and activity related entities
In addition to the ICF classes that have been selected thanks to a validated mapping with a literature variable, the majority of the  ICF classes were selected by medical experts from data scientists' suggestions according to the following process:
Starting from the selected phenotypic abnormalities, without including the ancestry from step i, and according to the following criteria:
When a body structure may be a phenotype location
When a body function may be impacted by a phenotype
When an activity or participation may be impacted by a phenotype
Starting from the herebefore selected body structure and body function, according to the following criteria:
Control if a relation may indeed exist between the body structure and the activity, both selected because of being in a relation with a phenotype, such as the body structure is involved in the activity. If not, if there is no activity proposed or if the body structure and the activity are not supposed to be related regarding the studied NMD, selection of the appropriate activity to be related with the body structure if such an activity exists regarding the studied NMD.
Control if a relation may indeed exist between the body function and the activity, both selected because of being in a relation with a phenotype, such as the body function is involved in the activity. If not, if there is no activity proposed or if the body function and the activity are not supposed to be related regarding the studied NMD, selection of the appropriate activity to be related with the body function if such an activity exists regarding the studied NMD.
Starting from all the herebefore selected ICF entities:
Import of the ICF ancestry of the selected ICF entities.
Selection of anatomical entities
When an anatomical entity may be a phenotype location.
Selection of the ancestry of herebefore selected FMA entities

Selection of procedures
Medical experts listed the categories of procedures to be included.
Starting from the selected phenotypes, activities and  body functions selected in ii.a and ii.b, selection by ME of categories of procedures to be linked with the assessed entities.

Selection of ‘assistive equipments’ and ‘aids to vision’
Medical experts selected a list of assistive equipments to be included in the model
Clinical research form provides some technical aids to be included in the modem

Selection of  ‘information content entities’
The following sources were used to determine the detailed information content entities to be included in PROMOT ontology:
Clinical research form
EURO NMD (46 NMD data elements - EU-CDEs and NMD-CDEs)
RD CDM (78 data elements, 6 terminologies or ontologies used, customed codes)
Medical experts selected elements
Then, more generic entities such as ‘year of onset’ were created in order to address the possible lack of information for an entity such as ‘date of onset’. 
Scores

Selection of  qualifiers

We relied on existing qualifiers from different ontologies to add precisions to our model, for example, about the level of body function impairment or the severity of a phenotype. These qualifiers have been used in other projects [24], for example by Prodinger et al to… XXX [28]. We also relied on statements, which are triplets of information used to define the properties of a concept or to link classes.
Qualifiers from existing ontologies were proposed by DS to ME that validated them. 


Definition of the relations between the ontology classes:
The criteria used in a.ii.a. and a.ii.b. were used to state the relations between the phenotypes and the ICF entities and the relations between ICF entities.
The criterion used in a.iii was used to state a relation between the phenotypes and the anatomical entities.
The anatomical entities and body structures were linked when they shared a connection through a phenotype.
Body structures and body functions were also linked when they shared a relation with the same phenotype.
Medical experts linked the selected phenotypes (ancestry excluded) with a selected procedure

Selection of the ontology properties	
Object properties
Object properties from existing ontologies were proposed by DS to ME that validated them.
Annotation properties
Creation of an annotation property ‘found in’ to state the reference for a selected phenotype
Data properties

