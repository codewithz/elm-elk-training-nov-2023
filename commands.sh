curl -XPUT 127.0.0.1:9200/_bulk?pretty -HContent-Type:application/json --data-binary @movies.json

#-------------------------- New Mapping for Movies--------------------------

{
    "mappings":{
        "properties":{
            "id":{
                "type":"integer"
            },
            "year":{
                "type":"date"
            },
             "genre":{
                "type":"keyword"
            },
             "title":{
                "type":"text","analyzer":"english"
            }
        }
    }
}

#-------------------- Mapping for Series ---------------------------------------

{
    "mappings":{
        "properties":{
            "film_to_franchise":{
                "type":"join",
                "relations":{"franchise":"film"}
            }
        }
    }
}

#---------------------- Query for Franchise and Film-----------------------

{
    "query":{
        "has_parent":{
            "parent_type":"franchise",
            "query":{
                "match":{
                    "title":"Star Wars"
                }
            }
        }
    }
}
