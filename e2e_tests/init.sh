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
    "truthfulnesses": [
        false
    ]
}'
}

init_json_array_no_pop_lists() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --populate-lists=false 2>&1`
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

init_json_integer_and_required() {
    output=`printf '{
    "title": "Person",
    "type": "object",
    "properties": {
        "firstName": {
            "type": "string"
        },
        "age": {
            "description": "Age in years",
            "type": "integer",
            "minimum": 0
        }
    },
    "required": ["firstName", "age"]
}' | schema init 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "age": 0,
    "firstName": ""
}'
    expect_or='{
    "firstName": "",
    "age": 0
}'
}

init_yaml_minimal() {
    output=`printf '{}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

init_yaml_string() {
    output=`printf '{"name": "Thomas"}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='name: ""'
}

init_yaml_number() {
    output=`printf '{"age": 20}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='age: 0'
}

init_yaml_boolean() {
    output=`printf '{"isHandsome": true}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='isHandsome: false'
}

init_yaml_null() {
    output=`printf '{"badField": null}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='badField: null'
}

init_yaml_array() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='truthfulnesses:
- false'
}

init_yaml_array_no_populate_lists() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --yaml --populate-lists=false 2>&1`
    status="$?"

    expect_status='0'
    expect='truthfulnesses: []'
}

init_yaml_nested_object() {
    output=`printf '{"myObj": {"field1":1,"field2":"Finland"}}' | schema infer | schema init --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='myObj:
  field1: 0
  field2: ""'
}

init_yaml_integer_and_required() {
    output=`printf '{
    "title": "Person",
    "type": "object",
    "properties": {
        "firstName": {
            "type": "string"
        },
        "age": {
            "description": "Age in years",
            "type": "integer",
            "minimum": 0
        }
    },
    "required": ["firstName", "age"]
}' | schema init --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='age: 0
firstName: ""'
    expect_or='firstName: ""
age: 0'
}

init_toml_minimal() {
    output=`printf '{}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

init_toml_string() {
    output=`printf '{"name": "Thomas"}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='0'
    expect='name = ""'
}

init_toml_number() {
    output=`printf '{"age": 20}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='0'
    expect='age = 0'
}

init_toml_boolean() {
    output=`printf '{"isHandsome": true}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='0'
    expect='isHandsome = false'
}

init_toml_null() {
    output=`printf '{"badField": null}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='1'
    expect='error: failed to serialize instance of schema
toml: cannot marshal nil interface {}'
}

init_toml_array() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='0'
    expect='truthfulnesses = [false]'
}

init_toml_array_no_populate_lists() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --toml --populate-lists=false 2>&1`
    status="$?"

    expect_status='0'
    expect='truthfulnesses = []'
}

init_toml_nested_object() {
    output=`printf '{"myObj": {"field1":1,"field2":"Finland"}}' | schema infer | schema init --toml 2>&1`
    status="$?"

    expect_status='0'
    expect='[myObj]
field1 = 0
field2 = ""'
}

init_toml_integer_and_required() {
    output=`printf '{
    "title": "Person",
    "type": "object",
    "properties": {
        "firstName": {
            "type": "string"
        },
        "age": {
            "description": "Age in years",
            "type": "integer",
            "minimum": 0
        }
    },
    "required": ["firstName", "age"]
}' | schema init --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='age = 0
firstName = ""'
    expect_or='firstName = ""
age = 0'
}

tests=(
    "init_invalid_schema"
    "init_json_minimal"
    "init_json_string"
    "init_json_number"
    "init_json_boolean"
    "init_json_null"
    "init_json_array"
    "init_json_array_no_pop_lists"
    "init_json_nested_object"
    "init_json_integer_and_required"
    "init_yaml_minimal"
    "init_yaml_string"
    "init_yaml_number"
    "init_yaml_boolean"
    "init_yaml_null"
    "init_yaml_array"
    "init_yaml_array_no_populate_lists"
    "init_yaml_nested_object"
    "init_yaml_integer_and_required"
    "init_toml_minimal"
    "init_toml_string"
    "init_toml_number"
    "init_toml_boolean"
    "init_toml_null"
    "init_toml_array"
    "init_toml_array_no_populate_lists"
    "init_toml_nested_object"
    "init_toml_integer_and_required"
)
