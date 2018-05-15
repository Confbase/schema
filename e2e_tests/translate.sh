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

translate_json_to_xml_minimal() {
    output=`printf '{}' | schema translate --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc/>'
}

translate_json_to_xml_basic() {
    output=`printf '{"name":"Bladee","Iceland":42}' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>42</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>42</Iceland>
</doc>'
}

translate_json_to_xml_bool() {
    output=`printf '{"name":"Bladee","Iceland":true}' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>true</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>true</Iceland>
</doc>'
}

translate_json_to_xml_array_of_objects() {
    output=`printf '{"people":[{"name":"Shane MacGowan"},{"name":"The Snake"}]}' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
    expect_or='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
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

translate_yaml_to_xml_minimal() {
    output=`printf '{}' | schema translate --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc/>'
}

translate_yaml_to_xml_basic() {
    output=`printf 'name: Bladee\nIceland: 42' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>42</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>42</Iceland>
</doc>'
}

translate_yaml_to_xml_bool() {
    output=`printf 'name: Bladee\nIceland: true' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>true</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>true</Iceland>
</doc>'
}

translate_yaml_to_xml_array_of_objects() {
    output=`printf 'people:\n- name: "Shane MacGowan"\n- name: "The Snake"' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
    expect_or='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
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


translate_toml_to_xml_minimal() {
    output=`printf '{}' | schema translate --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc/>'
}

translate_toml_to_xml_basic() {
    output=`printf 'name = "Bladee"\nIceland = 42' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>42</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>42</Iceland>
</doc>'
}

translate_toml_to_xml_bool() {
    output=`printf 'name = "Bladee"\nIceland = true' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>true</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>true</Iceland>
</doc>'
}

translate_toml_to_xml_array_of_objects() {
    output=`printf '[[people]]\nname = "Shane MacGowan"\n\n[[people]]\nname = "The Snake"' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
    expect_or='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
}

translate_xml_to_json_minimal() {
    output=`printf '' | schema translate 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_xml_to_json_basic() {
    output=`printf '<doc><name>Bladee</name><Iceland>42</Iceland></doc>' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "doc": {
        "Iceland": "42",
        "name": "Bladee"
    }
}' # cannot infer numbers from XML
    expect_or='{
    "doc": {
        "name": "Bladee",
        "Iceland": "42"
    }
}' # cannot infer numbers from XML
}

translate_xml_to_json_bool() {
    output=`printf '<doc><name>Bladee</name><Iceland>true</Iceland></doc>' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "doc": {
        "Iceland": "true",
        "name": "Bladee"
    }
}' # cannot infer bools from XML
    expect_or='{
    "doc": {
        "name": "Bladee",
        "Iceland": "true"
    }
}' # cannot infer bools from XML
}

translate_xml_to_json_array_of_objects() {
    output=`printf '<doc><people><name>Shane MacGowan</name></people><people><name>The Snake</name></people></doc>' | schema translate 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='{
    "doc": {
        "people": [
            {
                "name": "Shane MacGowan"
            },
            {
                "name": "The Snake"
            }
        ]
    }
}'
    expect_or='{
    "doc": {
        "people": [
            {
                "name": "The Snake"
            },
            {
                "name": "Shane MacGowan"
            }
        ]
    }
}'
}

translate_xml_to_yaml_minimal() {
    output=`printf '' | schema translate --yaml 2>&1`
    status="$?"

    expect_status='0'
    expect='{}'
}

translate_xml_to_yaml_basic() {
    output=`printf '<doc><name>Bladee</name><Iceland>42</Iceland></doc>' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='doc:
  name: Bladee
  Iceland: "42"' # cannot infer numbers from XML
    expect_or='doc:
  Iceland: "42"
  name: Bladee' # cannot infer numbers from XML
}

translate_xml_to_yaml_bool() {
    output=`printf '<doc><name>Bladee</name><Iceland>true</Iceland></doc>' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='doc:
  name: Bladee
  Iceland: "true"'
    expect_or='doc:
  Iceland: "true"
  name: Bladee'
}

translate_xml_to_yaml_array_of_objects() {
    output=`printf '<doc><people><name>Shane MacGowan</name></people><people><name>The Snake</name></people></doc>' | schema translate --yaml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='doc:
  people:
  - name: Shane MacGowan
  - name: The Snake'
    expect_or='doc:
  people:
  - name: The Snake
  - name: Shane MacGowan'
}

translate_xml_to_toml_minimal() {
    output=`printf '' | schema translate --toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

translate_xml_to_toml_basic() {
    output=`printf '<doc><name>Bladee</name><Iceland>42</Iceland></doc>' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[doc]
Iceland = "42"
name = "Bladee"' # cannot infer numbers from XML
    expect_or='[doc]
Iceland = "42"
name = "Bladee"' # cannot infer numbers from XML
}

translate_xml_to_toml_bool() {
    output=`printf '<doc><name>Bladee</name><Iceland>true</Iceland></doc>' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[doc]
Iceland = "true"
name = "Bladee"'
    expect_or='[doc]
name = "Bladee"
Iceland = "true"'
}

translate_xml_to_toml_array_of_objects() {
    output=`printf '<doc><people><name>Shane MacGowan</name></people><people><name>The Snake</name></people></doc>' | schema translate --toml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='[[doc.people]]
name = "Shane MacGowan"

[[doc.people]]
name = "The Snake"'
    expect_or='[[doc.people]]
name = "The Snake"

[[doc.people]]
name = "Shane MacGowan"'
}

translate_xml_to_xml_minimal() {
    output=`printf '' | schema translate --xml 2>&1`
    status="$?"

    expect_status='0'
    expect='<doc/>'
}

translate_xml_to_xml_basic() {
    output=`printf '<doc><name>Bladee</name><Iceland>42</Iceland></doc>' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>42</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>42</Iceland>
</doc>'
}

translate_xml_to_xml_bool() {
    output=`printf '<doc><name>Bladee</name><Iceland>true</Iceland></doc>' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <Iceland>true</Iceland>
    <name>Bladee</name>
</doc>'
    expect_or='<doc>
    <name>Bladee</name>
    <Iceland>true</Iceland>
</doc>'
}

translate_xml_to_xml_array_of_objects() {
    output=`printf '<doc><people><name>Shane MacGowan</name></people><people><name>The Snake</name></people></doc>' | schema translate --xml 2>&1`
    status="$?"

    expect_either_or='true'
    expect_status='0'
    expect_either='<doc>
    <people>
        <name>Shane MacGowan</name>
    </people>
    <people>
        <name>The Snake</name>
    </people>
</doc>'
    expect_or='<doc>
    <people>
        <name>The Snake</name>
    </people>
    <people>
        <name>Shane MacGowan</name>
    </people>
</doc>'
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
    "translate_json_to_xml_minimal"
    "translate_json_to_xml_basic"
    "translate_json_to_xml_bool"
    "translate_json_to_xml_array_of_objects"
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
    "translate_yaml_to_xml_minimal"
    "translate_yaml_to_xml_basic"
    "translate_yaml_to_xml_bool"
    "translate_yaml_to_xml_array_of_objects"
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
    "translate_toml_to_xml_minimal"
    "translate_toml_to_xml_basic"
    "translate_toml_to_xml_bool"
    "translate_toml_to_xml_array_of_objects"
    "translate_xml_to_json_minimal"
    "translate_xml_to_json_basic"
    "translate_xml_to_json_bool"
    "translate_xml_to_json_array_of_objects"
    "translate_xml_to_yaml_minimal"
    "translate_xml_to_yaml_basic"
    "translate_xml_to_yaml_bool"
    "translate_xml_to_yaml_array_of_objects"
    "translate_xml_to_toml_minimal"
    "translate_xml_to_toml_basic"
    "translate_xml_to_toml_bool"
    "translate_xml_to_toml_array_of_objects"
    "translate_xml_to_xml_minimal"
    "translate_xml_to_xml_basic"
    "translate_xml_to_xml_bool"
    "translate_xml_to_xml_array_of_objects"
)
