#!/bin/bash

translate_unrecognized_format() {
    output=`printf '{' | schema translate 2>&1`
    status="$?"

    expect_status='1'
    expect='error: failed to recognize input data format'
}

translate_json_to_json_minimal() {
    output=`printf '{}' | schema translate 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_json_to_json_basic() {
    output=`printf '{"name":"Bladee","Iceland":42}' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "name": "Bladee",
    "Iceland": 42
}'
    expect_or='{
    "Iceland": 42,
    "name": "Bladee"
}'
}

translate_json_to_json_bool() {
    output=`printf '{"name":"Bladee","Iceland":true}' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "name": "Bladee",
    "Iceland": true
}'
    expect_or='{
    "Iceland": true,
    "name": "Bladee"
}'
}

translate_json_to_json_array_of_objects() {
    output=`printf '{"people":[{"name":"Shane MacGowan","ring":"The Snake"}]}' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "people": [
        {
            "name": "Shane MacGowan",
            "ring": "The Snake"
        }
    ]
}'
    expect_or='{
    "people": [
        {
            "ring": "The Snake",
            "name": "Shane MacGowan"
        }
    ]
}'
}

translate_json_to_yaml_minimal() {
    output=`printf '{}' | schema translate --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_json_to_yaml_basic() {
    output=`printf '{"name":"Bladee","Iceland":42}' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name: Bladee
Iceland: 42'
    expect_or='Iceland: 42
name: Bladee'
}

translate_json_to_yaml_bool() {
    output=`printf '{"name":"Bladee","Iceland":true}' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name: Bladee
Iceland: true'
    expect_or='Iceland: true
name: Bladee'
}

translate_json_to_yaml_array_of_objects() {
    output=`printf '{"people":[{"name":"Shane MacGowan","ring":"The Snake"}]}' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='people:
- name: Shane MacGowan
  ring: The Snake'
    expect_or='people:
- ring: The Snake
  name: Shane MacGowan'
}

translate_json_to_toml_minimal() {
    output=`printf '{}' | schema translate --toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

translate_json_to_toml_basic() {
    output=`printf '{"name":"Bladee","Iceland":42}' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name = "Bladee"
Iceland = 4.2e+01'
    expect_or='Iceland = 4.2e+01
name = "Bladee"'
}

translate_json_to_toml_bool() {
    output=`printf '{"name":"Bladee","Iceland":true}' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name = "Bladee"
Iceland = true'
    expect_or='Iceland = true
name = "Bladee"'
}

translate_json_to_toml_array_of_objects() {
    output=`printf '{"people":[{"name":"Shane MacGowan","ring":"The Snake"}]}' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[[people]]
name = "Shane MacGowan"
ring = "The Snake"'
    expect_or='[[people]]
ring = "The Snake"
name = "Shane MacGowan"'
}

translate_yaml_to_json_minimal() {
    output=`printf '{}' | schema translate 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_yaml_to_json_basic() {
    output=`printf 'name: Bladee\nIceland: 42' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "name": "Bladee",
    "Iceland": 42
}'
    expect_or='{
    "Iceland": 42,
    "name": "Bladee"
}'
}

translate_yaml_to_json_bool() {
    output=`printf 'name: Bladee\nIceland: true' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "name": "Bladee",
    "Iceland": true
}'
    expect_or='{
    "Iceland": true,
    "name": "Bladee"
}'
}

translate_yaml_to_json_array_of_objects() {
    output=`printf 'people:\n- name: "Shane MacGowan"\n  ring: "The Snake"' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "people": [
        {
            "name": "Shane MacGowan",
            "ring": "The Snake"
        }
    ]
}'
    expect_or='{
    "people": [
        {
            "ring": "The Snake",
            "name": "Shane MacGowan"
        }
    ]
}'
}

translate_yaml_to_yaml_minimal() {
    output=`printf '{}' | schema translate --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_yaml_to_yaml_basic() {
    output=`printf 'name: Bladee\nIceland: 42' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name: Bladee
Iceland: 42'
    expect_or='Iceland: 42
name: Bladee'
}

translate_yaml_to_yaml_bool() {
    output=`printf 'name: Bladee\nIceland: true' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name: Bladee
Iceland: true'
    expect_or='Iceland: true
name: Bladee'
}

translate_yaml_to_yaml_array_of_objects() {
    output=`printf 'people:\n- name: "Shane MacGowan"\n  ring: "The Snake"' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='people:
- name: Shane MacGowan
  ring: The Snake'
    expect_or='people:
- ring: The Snake
  name: Shane MacGowan'
}

translate_yaml_to_toml_minimal() {
    output=`printf '{}' | schema translate --toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

translate_yaml_to_toml_basic() {
    output=`printf 'name: Bladee\nIceland: 42' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name = "Bladee"
Iceland = 42'
    expect_or='Iceland = 42
name = "Bladee"'
}

translate_yaml_to_toml_bool() {
    output=`printf 'name: Bladee\nIceland: true' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name = "Bladee"
Iceland = true'
    expect_or='Iceland = true
name = "Bladee"'
}

translate_yaml_to_toml_array_of_objects() {
    output=`printf 'people:\n- name: "Shane MacGowan"\n  ring: "The Snake"' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[[people]]
name = "Shane MacGowan"
ring = "The Snake"'
    expect_or='[[people]]
ring = "The Snake"
name = "Shane MacGowan"'
}

translate_toml_to_json_minimal() {
    output=`printf '' | schema translate 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_toml_to_json_basic() {
    output=`printf 'name = "Bladee"\nIceland = 42' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "name": "Bladee",
    "Iceland": 42
}'
    expect_or='{
    "Iceland": 42,
    "name": "Bladee"
}'
}

translate_toml_to_json_bool() {
    output=`printf 'name = "Bladee"\nIceland = true' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "name": "Bladee",
    "Iceland": true
}'
    expect_or='{
    "Iceland": true,
    "name": "Bladee"
}'
}

translate_toml_to_json_array_of_objects() {
    output=`printf '[[people]]\nname = "Shane MacGowan"\nring = "The Snake"' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "people": [
        {
            "name": "Shane MacGowan",
            "ring": "The Snake"
        }
    ]
}'
    expect_or='{
    "people": [
        {
            "ring": "The Snake",
            "name": "Shane MacGowan"
        }
    ]
}'
}

translate_toml_to_yaml_minimal() {
    output=`printf '' | schema translate --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_toml_to_yaml_basic() {
    output=`printf 'name = "Bladee"\nIceland = 42' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name: Bladee
Iceland: 42'
    expect_or='Iceland: 42
name: Bladee'
}

translate_toml_to_yaml_bool() {
    output=`printf 'name = "Bladee"\nIceland = true' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name: Bladee
Iceland: true'
    expect_or='Iceland: true
name: Bladee'
}

translate_toml_to_yaml_array_of_objects() {
    output=`printf '[[people]]\nname = "Shane MacGowan"\nring = "The Snake"' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='people:
- name: Shane MacGowan
  ring: The Snake'
    expect_or='people:
- ring: The Snake
  name: Shane MacGowan'
}

translate_toml_to_toml_minimal() {
    output=`printf '' | schema translate --toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

translate_toml_to_toml_basic() {
    output=`printf 'name = "Bladee"\nIceland = 42' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name = "Bladee"
Iceland = 42'
    expect_or='Iceland = 42
name = "Bladee"'
}

translate_toml_to_toml_bool() {
    output=`printf 'name = "Bladee"\nIceland = true' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='name = "Bladee"
Iceland = true'
    expect_or='Iceland = true
name = "Bladee"'
}

translate_toml_to_toml_array_of_objects() {
    output=`printf '[[people]]\nname = "Shane MacGowan"\nring = "The Snake"' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[[people]]
name = "Shane MacGowan"
ring = "The Snake"'
    expect_or='[[people]]
ring = "The Snake"
name = "Shane MacGowan"'
}

tests=(
    "translate_unrecognized_format"
    "translate_json_to_json_minimal"
    "translate_json_to_json_basic"
    "translate_json_to_json_bool"
    "translate_json_to_json_array_of_objects"
    "translate_json_to_yaml_minimal"
    "translate_json_to_yaml_basic"
    "translate_json_to_yaml_bool"
    "translate_json_to_yaml_array_of_objects"
    "translate_json_to_toml_minimal"
    "translate_json_to_toml_basic"
    "translate_json_to_toml_bool"
    "translate_json_to_toml_array_of_objects"
    "translate_yaml_to_json_minimal"
    "translate_yaml_to_json_basic"
    "translate_yaml_to_json_bool"
    "translate_yaml_to_json_array_of_objects"
    "translate_yaml_to_yaml_minimal"
    "translate_yaml_to_yaml_basic"
    "translate_yaml_to_yaml_bool"
    "translate_yaml_to_yaml_array_of_objects"
    "translate_yaml_to_toml_minimal"
    "translate_yaml_to_toml_basic"
    "translate_yaml_to_toml_bool"
    "translate_yaml_to_toml_array_of_objects"
    "translate_toml_to_json_minimal"
    "translate_toml_to_json_basic"
    "translate_toml_to_json_bool"
    "translate_toml_to_json_array_of_objects"
    "translate_toml_to_yaml_minimal"
    "translate_toml_to_yaml_basic"
    "translate_toml_to_yaml_bool"
    "translate_toml_to_yaml_array_of_objects"
    "translate_toml_to_toml_minimal"
    "translate_toml_to_toml_basic"
    "translate_toml_to_toml_bool"
    "translate_toml_to_toml_array_of_objects"
)
