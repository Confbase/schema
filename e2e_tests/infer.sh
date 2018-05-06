#!/bin/bash

infer_unrecognized_format() {
    output=`printf '{' | schema infer 2>&1`
    status="$?"

    expect_status='1'
    expect='error: failed to recognize input data format'
}

infer_json_minimal() {
    output=`printf '{}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {},
    "required": []
}'
}

infer_json_string() {
    output=`printf '{"a":"b"}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "a": {
            "type": "string"
        }
    },
    "required": []
}'
}

infer_json_positive_integer() {
    output=`printf '{"myNumber":12}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "myNumber": {
            "type": "number"
        }
    },
    "required": []
}'
}

infer_json_negative_integer() {
    output=`printf '{"myNumber":-12310}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "myNumber": {
            "type": "number"
        }
    },
    "required": []
}'
}

infer_json_positive_float() {
    output=`printf '{"myNumber":420.6}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "myNumber": {
            "type": "number"
        }
    },
    "required": []
}'
}

infer_json_negative_float() {
    output=`printf '{"myNumber":-1902.32249}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "myNumber": {
            "type": "number"
        }
    },
    "required": []
}'
}

infer_json_zero() {
    output=`printf '{"myNumber":0}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "myNumber": {
            "type": "number"
        }
    },
    "required": []
}'
}

infer_json_boolean() {
    output=`printf '{"is2004":true}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "is2004": {
            "type": "boolean"
        }
    },
    "required": []
}'
}

infer_json_array_of_strings() {
    output=`printf '{"people":["bladee","thomas"]}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "type": "string"
            }
        }
    },
    "required": []
}'
}

infer_json_array_of_numbers() {
    output=`printf '{"ages":[12.1,-1,43,-2.3,0,-0,0.0]}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "ages": {
            "type": "array",
            "items": {
                "type": "number"
            }
        }
    },
    "required": []
}'
}

infer_json_array_of_booleans() {
    output=`printf '{"truthinesses":[true,false,false]}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "truthinesses": {
            "type": "array",
            "items": {
                "type": "boolean"
            }
        }
    },
    "required": []
}'
}

infer_json_array_of_objects() {
    output=`printf '{"people":[{"name":"thomas"},{"name":"gordon"}]}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
}

infer_json_array_of_array_objects() {
    output=`printf '{"people":[[{"name":"thomas"},{"name":"gordon"}]]}' | schema infer 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "type": "array",
                "items": {
                    "title": "",
                    "type": "object",
                    "properties": {
                        "name": {
                            "type": "string"
                        }
                    },
                    "required": []
                }
            }
        }
    },
    "required": []
}'
}

tests=(
    "infer_unrecognized_format"
    "infer_json_minimal"
    "infer_json_string"
    "infer_json_positive_integer"
    "infer_json_negative_integer"
    "infer_json_positive_float"
    "infer_json_negative_float"
    "infer_json_zero"
    "infer_json_boolean"
    "infer_json_array_of_strings"
    "infer_json_array_of_numbers"
    "infer_json_array_of_booleans"
    "infer_json_array_of_objects"
    "infer_json_array_of_array_objects"
)
