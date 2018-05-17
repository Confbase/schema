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

setup_init_json_follow_ref() {
    requires_network='true'
    status='0'
    expect_status='0'
}

init_json_follow_ref() {
    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "geo": {
        "latitude": 0,
        "longitude": 0
    }
}'
    expect_or='{
    "geo": {
        "longitude": 0,
        "latitude": 0
    }
}'
}

init_json_skip_ref() {
    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --skip-refs 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "geo": {}
}'
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

setup_init_yaml_follow_ref() {
    requires_network='true'
    status='0'
    expect_status='0'
}

init_yaml_follow_ref() {
    requires_network='true'

    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='geo:
  latitude: 0
  longitude: 0'
    expect_or='geo:
  longitude: 0
  latitude: 0'
}

init_yaml_skip_ref() {
    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --yaml --skip-refs 2>&1`
    status="$?"

    expect_status='0'
    expect='geo: {}'
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

setup_init_toml_follow_ref() {
    requires_network='true'
    status='0'
    expect_status='0'
}

init_toml_follow_ref() {
    requires_network='true'

    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[geo]
latitude = 0
longitude = 0'
    expect_or='[geo]
longitude = 0
latitude = 0'
}

init_toml_skip_ref() {
    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --toml --skip-refs 2>&1`
    status="$?"

    expect_status='0'
    expect='' # toml encodes to the empty string for empty objects
    # and nests of empty objects
}

init_xml_minimal() {
    output=`printf '{}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc/>'
}

init_xml_string() {
    output=`printf '{"name": "Thomas"}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<name/>'
}

init_xml_number() {
    output=`printf '{"age": 20}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<age>0</age>'
}

init_xml_boolean() {
    output=`printf '{"isHandsome": true}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<isHandsome>false</isHandsome>'
}

init_xml_null() {
    output=`printf '{"badField": null}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<badField/>'
}

init_xml_array() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc>
    <truthfulnesses>false</truthfulnesses>
</doc>'
}

init_xml_array_no_populate_lists() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --xml --populate-lists=false 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc>
    <truthfulnesses/></doc>'
}

init_xml_nested_object() {
    output=`printf '{"myObj": {"field1":1,"field2":"Finland"}}' | schema infer | schema init --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<myObj>
    <field1>0</field1>
    <field2/>
</myObj>'
}

init_xml_integer_and_required() {
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
}' | schema init --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <age>0</age>
    <firstName/>
</doc>'
    expect_or='<doc>
    <firstName/>
    <age>0</age>
</doc>'
}

setup_init_xml_follow_ref() {
    requires_network='true'
    status='0'
    expect_status='0'
}

init_xml_follow_ref() {
    requires_network='true'

    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<geo>
    <latitude>0</latitude>
    <longitude>0</longitude>
</geo>'
    expect_or='<geo>
    <longitude>0</longitude>
    <latitude>0</latitude>
</geo>'
}

init_xml_skip_ref() {
    output=`printf '{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "description": "A representation of a person, company, organization, or place",
    "type": "object",
    "properties": {
        "geo": { "$ref": "http://json-schema.org/geo" }
    }
}' | schema init --xml --skip-refs 2>&1`
    status="$?"

    expect_status='0'
    expect='<geo/>' # clbanning/mxj has this behavior...
}


init_random_minimal() {
    output=`printf '{}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {}
}'
}

init_random_string() {
    output=`printf '{"name": "Thomas"}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "name": {
            "type": "string"
        }
    }
}'
}

init_random_number() {
    output=`printf '{"age": 20}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "age": {
            "type": "number"
        }
    }
}'
}

init_random_boolean() {
    output=`printf '{"isHandsome": true}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "isHandsome": {
            "type": "boolean"
        }
    }
}'
}

init_random_null() {
    output=`printf '{"badField": null}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "badField": {
            "type": "null"
        }
    }
}'
}

init_random_array() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "truthfulnesses": {
            "type": "array",
            "items": {
                "type": "boolean"
            }
        }
    }
}'
}

init_random_array_no_pop_lists() {
    output=`printf '{"truthfulnesses": [true,false,false,true]}' | schema infer | schema init --populate-lists=false --random 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "truthfulnesses": []
}'
}

init_random_nested_object() {
    output=`printf '{"myObj": {"field1":1,"field2":"Finland"}}' | schema infer | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "myObj": {
            "title": "",
            "type": "object",
            "properties": {
                "field1": {
                    "type": "number"
                },
                "field2": {
                    "type": "string"
                }
            }
        }
    }
}'
}

init_random_integer_and_required() {
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
}' | schema init --random | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "age": {
            "type": "number"
        },
        "firstName": {
            "type": "string"
        }
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
    "init_json_array_no_pop_lists"
    "init_json_nested_object"
    "init_json_integer_and_required"
    "init_json_follow_ref"
    "init_json_skip_ref"
    "init_yaml_minimal"
    "init_yaml_string"
    "init_yaml_number"
    "init_yaml_boolean"
    "init_yaml_null"
    "init_yaml_array"
    "init_yaml_array_no_populate_lists"
    "init_yaml_nested_object"
    "init_yaml_integer_and_required"
    "init_yaml_follow_ref"
    "init_yaml_skip_ref"
    "init_toml_minimal"
    "init_toml_string"
    "init_toml_number"
    "init_toml_boolean"
    "init_toml_null"
    "init_toml_array"
    "init_toml_array_no_populate_lists"
    "init_toml_nested_object"
    "init_toml_integer_and_required"
    "init_toml_follow_ref"
    "init_toml_skip_ref"
    "init_xml_minimal"
    "init_xml_string"
    "init_xml_number"
    "init_xml_boolean"
    "init_xml_null"
    "init_xml_array"
    "init_xml_array_no_populate_lists"
    "init_xml_nested_object"
    "init_xml_integer_and_required"
    "init_xml_follow_ref"
    "init_xml_skip_ref"
    "init_random_minimal"
    "init_random_string"
    "init_random_number"
    "init_random_boolean"
    "init_random_null"
    "init_random_array"
    "init_random_array_no_pop_lists"
    "init_random_nested_object"
    "init_random_integer_and_required"
)
