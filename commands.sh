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
