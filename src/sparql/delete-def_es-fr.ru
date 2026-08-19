PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo:  <http://purl.obolibrary.org/obo/>

DELETE {
  ?entity obo:IAO_0000115 ?def .
}
WHERE {
  ?entity obo:IAO_0000115 ?def .
  FILTER(lang(?def) IN ("fr", "es")) .
}