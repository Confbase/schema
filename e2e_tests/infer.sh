#!/bin/bash

infer_unrecognized_format() {
    output=`printf '{' | schema infer 2>&1`
    status="$?"

    expect_status='1'
    expect='error: failed to recognize input data format'
}

infer_json_minimal() {
    output=`printf '{}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"a":"b"}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"myNumber":12}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"myNumber":-12310}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"myNumber":420.6}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"myNumber":-1902.32249}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"myNumber":0}' | schema infer --omit-required=false 2>&1`
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

infer_json_null() {
    output=`printf '{"is2004":null}' | schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "is2004": {
            "type": "null"
        }
    },
    "required": []
}'
}

infer_json_boolean() {
    output=`printf '{"is2004":true}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"people":["bladee","thomas"]}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"ages":[12.1,-1,43,-2.3,0,-0,0.0]}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"truthinesses":[true,false,false]}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"people":[{"name":"thomas"},{"name":"gordon"}]}' | schema infer --omit-required=false 2>&1`
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
    output=`printf '{"people":[[{"name":"thomas"},{"name":"gordon"}]]}' | schema infer --omit-required=false 2>&1`
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

infer_json_array_of_objects_with_multiple_fields() {
    output=`printf '{"people":[{"name":"Thomas","age":20}]}' | schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='{
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
                    },
                    "age": {
                        "type": "number"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
    expect_or='{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "age": {
                        "type": "number"
                    },
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

infer_json_complicated_and_use_schema_field() {
    output=`printf '{"people":[{"name":"Thomas","age":20}]}' \
| schema infer -s 'http://json-schema.org/draft-06/schema' --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='{
    "$schema": "http://json-schema.org/draft-06/schema",
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
                    },
                    "age": {
                        "type": "number"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
    expect_or='{
    "$schema": "http://json-schema.org/draft-06/schema",
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "age": {
                        "type": "number"
                    },
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

infer_yaml_string() {
    output=`printf 'color: red' | schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "color": {
            "type": "string"
        }
    },
    "required": []
}'
}

infer_yaml_positive_integer() {
    output=`printf 'myNumber: 12' | schema infer --omit-required=false 2>&1`
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

infer_yaml_negative_integer() {
    output=`printf 'myNumber: -12310' | schema infer --omit-required=false 2>&1`
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

infer_yaml_positive_float() {
    output=`printf 'myNumber: 420.6' | schema infer --omit-required=false 2>&1`
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

infer_yaml_negative_float() {
    output=`printf 'myNumber: -1902.32249' | schema infer --omit-required=false 2>&1`
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

infer_yaml_zero() {
    output=`printf 'myNumber: 0' | schema infer --omit-required=false 2>&1`
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

infer_yaml_null() {
    output=`printf 'is2004: ~' | schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "is2004": {
            "type": "null"
        }
    },
    "required": []
}'
}

infer_yaml_boolean() {
    output=`printf 'is2004: true' | schema infer --omit-required=false 2>&1`
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

infer_yaml_array_of_strings() {
    output=`printf 'people: ["bladee","thomas"]' | schema infer --omit-required=false 2>&1`
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

infer_yaml_array_of_numbers() {
    output=`printf 'ages: [12.1,-1,43,-2.3,0,-0,0.0]' | schema infer --omit-required=false 2>&1`
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

infer_yaml_array_of_booleans() {
    output=`printf 'truthinesses: [true,false,false]' | schema infer --omit-required=false 2>&1`
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

infer_yaml_array_of_objects() {
    output=`printf "people:\n  - name: thomas\n  - name: gordon" | schema infer --omit-required=false 2>&1`
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

infer_yaml_array_of_array_objects() {
    output=`printf "people:\n  -\n    - name: thomas\n  -\n    - name: gordon" | schema infer --omit-required=false 2>&1`
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

infer_yaml_array_of_objects_with_multiple_fields() {
    output=`printf "people:\n  - name: thomas\n    age: 20\n  - name: gordon\n    age: 60" \
| schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='{
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
                    },
                    "age": {
                        "type": "number"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
    expect_or='{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "age": {
                        "type": "number"
                    },
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

infer_yaml_complicated_and_use_schema_field() {
    output=`printf "people:\n  - name: thomas\n    age: 20\n  - name: gordon\n    age: 60" \
| schema infer -s 'http://json-schema.org/draft-06/schema' --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='{
    "$schema": "http://json-schema.org/draft-06/schema",
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
                    },
                    "age": {
                        "type": "number"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
    expect_or='{
    "$schema": "http://json-schema.org/draft-06/schema",
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "age": {
                        "type": "number"
                    },
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

infer_toml_string() {
    output=`printf 'color = "red"' | schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='{
    "title": "",
    "type": "object",
    "properties": {
        "color": {
            "type": "string"
        }
    },
    "required": []
}'
}

infer_toml_positive_integer() {
    output=`printf 'myNumber = 12' | schema infer --omit-required=false 2>&1`
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

infer_toml_negative_integer() {
    output=`printf 'myNumber = -12310' | schema infer --omit-required=false 2>&1`
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

infer_toml_positive_float() {
    output=`printf 'myNumber = 420.6' | schema infer --omit-required=false 2>&1`
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

infer_toml_negative_float() {
    output=`printf 'myNumber = -1902.32249' | schema infer --omit-required=false 2>&1`
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

infer_toml_zero() {
    output=`printf 'myNumber = 0' | schema infer --omit-required=false 2>&1`
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

infer_toml_boolean() {
    output=`printf 'is2004 = true' | schema infer --omit-required=false 2>&1`
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

infer_toml_array_of_strings() {
    output=`printf 'people = ["bladee","thomas"]' | schema infer --omit-required=false 2>&1`
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

infer_toml_array_of_floats() {
    output=`printf 'ages = [ 12.1, -1.0, 43.0, -2.3, 0.0, -0.0, 0.0 ]' | schema infer --omit-required=false 2>&1`
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

infer_toml_array_of_ints() {
    output=`printf 'ages = [ 12, -1, 43, -2, 0, -0, 0 ]' | schema infer --omit-required=false 2>&1`
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

infer_toml_array_of_booleans() {
    output=`printf 'truthinesses = [ true, false, false ]' | schema infer --omit-required=false 2>&1`
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

infer_toml_array_of_tables() {
    output=`printf "[[people]]\nname = 'thomas'\n\n[[people]]\nname = 'gordon'" | schema infer --omit-required=false 2>&1`
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


infer_toml_array_of_tables_with_multiple_fields() {
    output=`printf "[[people]]\nname = 'thomas'\nage = 20\n\n[[people]]\nname = 'gordon'\nage = 60" \
| schema infer --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='{
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
                    },
                    "age": {
                        "type": "number"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
    expect_or='{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "age": {
                        "type": "number"
                    },
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

infer_toml_complicated_and_use_schema_field() {
    output=`printf "[[people]]\nname = 'thomas'\nage = 20\n\n[[people]]\nname = 'gordon'\nage = 60" \
| schema infer -s 'http://json-schema.org/draft-06/schema' --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='{
    "$schema": "http://json-schema.org/draft-06/schema",
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
                    },
                    "age": {
                        "type": "number"
                    }
                },
                "required": []
            }
        }
    },
    "required": []
}'
    expect_or='{
    "$schema": "http://json-schema.org/draft-06/schema",
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "age": {
                        "type": "number"
                    },
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

infer_unrecognized_format_graphql() {
    output=`printf '{' | schema infer --graphql 2>&1`
    status="$?"

    expect_status='1'
    expect='error: failed to recognize input data format'
}

infer_json_minimal_graphql() {
    output=`printf '{}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
}'
}

infer_json_string_graphql() {
    output=`printf '{"a":"b"}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    a: String!
}'
}

infer_json_positive_integer_graphql() {
    output=`printf '{"myNumber":12}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    myNumber: Float!
}'
}

infer_json_negative_integer_graphql() {
    output=`printf '{"myNumber":-12310}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    myNumber: Float!
}'
}

infer_json_positive_float_graphql() {
    output=`printf '{"myNumber":420.6}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    myNumber: Float!
}'
}

infer_json_negative_float_graphql() {
    output=`printf '{"myNumber":-1902.32249}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    myNumber: Float!
}'
}

infer_json_zero_graphql() {
    output=`printf '{"myNumber":0}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    myNumber: Float!
}'
}

infer_json_null_graphql() {
    output=`printf '{"is2004":null}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='1'
    expect=`printf "error: failed to serialize schema\ncannot infer type of null value (see key 'is2004')"`
}

infer_json_boolean_graphql() {
    output=`printf '{"is2004":true}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    is2004: Boolean!
}'
}

infer_json_array_of_strings_graphql() {
    output=`printf '{"people":["bladee","thomas"]}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    people: [String!]!
}'
}

infer_json_array_of_numbers_graphql() {
    output=`printf '{"ages":[12.1,-1,43,-2.3,0,-0,0.0]}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    ages: [Float!]!
}'
}

infer_json_array_of_booleans_graphql() {
    output=`printf '{"truthinesses":[true,false,false]}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type Object {
    truthinesses: [Boolean!]!
}'
}

infer_json_array_of_objects_graphql() {
    output=`printf '{"people":[{"name":"thomas"},{"name":"gordon"}]}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type People {
    name: String!
}

type Object {
    people: [People!]!
}'
}

infer_json_array_of_array_objects_graphql() {
    output=`printf '{"people":[[{"name":"thomas"},{"name":"gordon"}]]}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect='type People {
    name: String!
}

type Object {
    people: [[People!]]!
}'
}

infer_json_array_of_objects_with_multiple_fields_graphql() {
    output=`printf '{"people":[{"name":"Thomas","age":20}]}' | schema infer --graphql --omit-required=false 2>&1`
    status="$?"

    expect_status='0'
    expect_either_or='true'
    expect_either='type People {
    age: Float!
    name: String!
}

type Object {
    people: [People!]!
}'
    expect_or='type People {
    name: String!
    age: Float!
}

type Object {
    people: [People!]!
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
    "infer_json_null"
    "infer_json_boolean"
    "infer_json_array_of_strings"
    "infer_json_array_of_numbers"
    "infer_json_array_of_booleans"
    "infer_json_array_of_objects"
    "infer_json_array_of_array_objects"
    "infer_json_array_of_objects_with_multiple_fields"
    "infer_json_complicated_and_use_schema_field"
    "infer_yaml_string"
    "infer_yaml_positive_integer"
    "infer_yaml_negative_integer"
    "infer_yaml_positive_float"
    "infer_yaml_negative_float"
    "infer_yaml_zero"
    "infer_yaml_null"
    "infer_yaml_boolean"
    "infer_yaml_array_of_strings"
    "infer_yaml_array_of_numbers"
    "infer_yaml_array_of_booleans"
    "infer_yaml_array_of_objects"
    "infer_yaml_array_of_array_objects"
    "infer_yaml_array_of_objects_with_multiple_fields"
    "infer_yaml_complicated_and_use_schema_field"
    "infer_toml_string"
    "infer_toml_positive_integer"
    "infer_toml_negative_integer"
    "infer_toml_positive_float"
    "infer_toml_negative_float"
    "infer_toml_zero"
    "infer_toml_boolean"
    "infer_toml_array_of_strings"
    "infer_toml_array_of_floats"
    "infer_toml_array_of_ints"
    "infer_toml_array_of_booleans"
    "infer_toml_array_of_tables"
    "infer_toml_array_of_tables_with_multiple_fields"
    "infer_toml_complicated_and_use_schema_field"
    "infer_unrecognized_format_graphql"
    "infer_json_minimal_graphql"
    "infer_json_string_graphql"
    "infer_json_positive_integer_graphql"
    "infer_json_negative_integer_graphql"
    "infer_json_positive_float_graphql"
    "infer_json_negative_float_graphql"
    "infer_json_zero_graphql"
    "infer_json_null_graphql"
    "infer_json_boolean_graphql"
    "infer_json_array_of_strings_graphql"
    "infer_json_array_of_numbers_graphql"
    "infer_json_array_of_booleans_graphql"
    "infer_json_array_of_objects_graphql"
    "infer_json_array_of_array_objects_graphql"
    "infer_json_array_of_objects_with_multiple_fields_graphql"
)
