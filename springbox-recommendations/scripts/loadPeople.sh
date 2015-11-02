#!/bin/bash
TOKEN="$1"
ROUTE="$2:$3"
curl ${ROUTE}/people -X POST -d '{"userName":"mstine","firstName":"Matt","lastName":"Stine"}' -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}"
curl ${ROUTE}/people -X POST -d '{"userName":"starbuxman","firstName":"Josh","lastName":"Long"}' -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}"
curl ${ROUTE}/people -X POST -d '{"userName":"littleidea","firstName":"Andrew","lastName":"Shafer"}' -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}"
