#!/bin/bash

init_invalid_schema() {
    output=`printf '{' | schema init 2>&1`
    status="$?"

    expect_status='1'
    expect='error: failed to parse data from stdin as JSON
unexpected EOF'
}

init_json_minimal() {
    output=`printf '{}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

init_json_string() {
    output=`printf '{"name": "Thomas"}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "name": ""
}'
}

init_json_number() {
    output=`printf '{"age": 20}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "age": 0
}'
}

init_json_boolean() {
    output=`printf '{"isHandsome": true}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "isHandsome": false
}'
}

init_json_null() {
    output=`printf '{"badField": null}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "badField": null
}'
}

init_json_array() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "truthfulnesses": []
}'
}

init_json_nested_object() {
    output=`printf '{"myObj": {"field1":1,"field2":"Finland"}}' | schema infer | schema init 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "myObj": {
        "field1": 0,
        "field2": ""
    }
}'
}

tests=(
    "init_invalid_schema"
    "init_json_minimal"
    "init_json_string"
    "init_json_number"
    "init_json_boolean"
    "init_json_null"
    "init_json_array"
    "init_json_nested_object"
)
