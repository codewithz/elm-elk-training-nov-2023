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

curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "match": {
        "title": "star"
        }
    }
}'


#---------------------- Query -----------------------
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d'
{
    "query":{
    "bool": {
        "must": {"term": {"title": "trek"}},
        "filter": {"range": {"year": {"gte": 2010}}}
    }
    }
}'
#---------------------- Query with Boolean Filter-----------------------
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d'
{
    "query":{
    "bool": {
        "must": {"term": {"title": "trek"}},
        "filter": {"range": {"year": {"gte": 2010}}}
     }
    }
}


#---------------------- Phrase Search -----------------------
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "match_phrase": {
        "title": "star wars"
        }
    }
}'
#---------------------- Slop -----------------------
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "match_phrase": {
        "title": {"query": "star beyond", "slop": 1}
        }
    }
}'

curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "match_phrase": {
        "title": {"query": "star beyond", "slop": 100}
        }
    }
}'

#---------------------- Pagination -----------------------
curl -XGET '127.0.0.1:9200/movies/_search?size=2&from=2&pretty'


curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
"from": 2,
"size": 2,
"query": {"match": {"genre": "Sci-Fi"}}
}'


#---------------------- Sorting -----------------------


curl -XGET '127.0.0.1:9200/movies/_search?sort=year&pretty'


curl -XPUT 127.0.0.1:9200/movies/ -d '
{
    "mappings": {
        "properties" : {
            "title": {
                "type" : “text",
                    "fields": {
                        "raw": {
                        "type": “keyword“
                        }
                } 
            }
        }
    }
}



curl -XGET '127.0.0.1:9200/movies/_search?sort=title.raw&pretty'


curl -XGET 127.0.0.1:9200/movies/_search?pretty -d'
{
    "query":{
        "bool": {
            "must": {"match": {"genre": "Sci-Fi"}},
            "must_not": {"match": {"title": "trek"}},
            "filter": {"range": {"year": {"gte": 2010, "lt": 2015}}}
        }
    }
}

#---------------------- Fuzzy -----------------------
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "fuzzy": {
        "title": {"value": "intrsteller", "fuzziness": 2}
        }
    }
}'



curl -XGET '127.0.0.1:9200/movies/_search?pretty' -d '
{
    "query": {
        "prefix": {
        "year": "201"
        }
    }
}'

curl -XGET '127.0.0.1:9200/movies/_search?pretty' -d '
{
    "query": {
        "wildcard": {
        "year": "1*"
        }
    }
}'


#---------------------- N-Gram -----------------------

curl -XGET '127.0.0.1:9200/movies/_search?pretty' -d '
{
    "query": {
        "match_phrase_prefix": {
            "title": {
            "query": "star trek",
            "slop": 10
            }
        }
    }
}'

"star":
unigram: [ s, t, a, r ]
bigram: [ st, ta, ar ]
trigram: [ sta, tar ]
4-gram: [ star ]


Create an 
"autocomplete" 
analyzer

curl -XPUT '127.0.0.1:9200/movies?pretty' -d '
{
  "settings": {
    "analysis": {
      "filter": {
        "autocomplete_filter": {
          "type": "edge_ngram",
          "min_gram": 1,
          "max_gram": 20
        }
      },
      "analyzer": {
        "autocomplete": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "autocomplete_filter"]
        }
      }
    }
  }
}'


curl -XPUT '127.0.0.1:9200/movies/_mapping?pretty' -d '
{
    "properties" : {
        "title": {
        "type" : "string",
        "analyzer": "autocomplete"
        } 
    }
}'


curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "match": {
            "title": {
            "query": "sta",
            "analyzer": "standard"
            }
        }
    }
}'


#------------- Aggregations---------------------------
curl -XGET 127.0.0.1:9200/ratings/_search?size=0&pretty -d '
{
    "aggs":{
        "ratings":{
            "terms":{
                "field":"rating"
            }
        }
    }
}'

# -------- Average Rating for Star Wars
curl -XGET 127.0.0.1:9200/ratings/_search?size=0&pretty -d '
{
    "query":{
        "match_phrase":{
            "title":"Star Wars Episode IV"
        }
    }
    "aggs":{
        "ratings":{
            "terms":{
                "field":"rating"
            }
        }
    }
}'
#--------- Average Rating for Star Wars-----------
curl -XGET 127.0.0.1:9200/ratings/_search?pretty -d '
{

    "query":{
        "match_phrase":{
            "title":"Star Wars Episode IV"
        }
    },
    "aggs":{
        "ratings":{
            "terms":{
                "field":"rating"
            }
        }
    }
}'

#------------- Histogram ------------------

curl -XGET 127.0.0.1:9200/ratings/_search?pretty -d '
{
    "aggs":{
        "whole_ratings":{
            "histogram":{
                "field":"rating",
                "interval":1.0
            }
        }
    }
}'




