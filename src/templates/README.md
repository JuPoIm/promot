# Directory for customized ROBOT templates
# Dossier pour les templates ROBOT du projet

## Input templates
- icf_labels-es-fr.tsv

    automatically created ROBOT template with the French and Spanish translations for ICF labels

- promot-component-base.tsv

    hand edited ROBOT template for creating PROMOT classes, asserting PROMOT hierarchy using imported classes

## Output template
- promot-component-auto.tsv

    automatically created ROBOT template combining icf_labels-es-fr.tsv, promot-component-base.tsv and the axioms listed in the data/promot/axioms_*.tsv files
    this template is the one used to create src/ontology/components/promot-component.owl
