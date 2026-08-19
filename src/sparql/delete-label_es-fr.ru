PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo:  <http://purl.obolibrary.org/obo/>

DELETE {
  ?entity rdfs:label ?label .
  ?entity obo:IAO_0000115 ?def .
}
WHERE {
  {
    ?entity rdfs:label ?label .
    FILTER(langMatches(lang(?label), "fr") || langMatches(lang(?label), "es"))
  }
  UNION
  {
    ?entity obo:IAO_0000115 ?def .
    FILTER(langMatches(lang(?def), "fr") || langMatches(lang(?def), "es"))
  }
}