#!/bin/bash

diff_array_of_objects_json1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.json \
    e2e_tests/diff_test_files/array_of_objects2.json 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_json2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.json \
    e2e_tests/diff_test_files/array_of_objects1.json 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_json_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.json \
    e2e_tests/diff_test_files/array_of_objects1.json 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_json_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.json \
    e2e_tests/diff_test_files/array_of_objects2.json 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_json1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.json \
    e2e_tests/diff_test_files/minimal_differing_types2.json 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_json2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.json \
    e2e_tests/diff_test_files/minimal_differing_types1.json 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_json_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.json \
    e2e_tests/diff_test_files/minimal_differing_types1.json 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_json_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.json \
    e2e_tests/diff_test_files/minimal_differing_types2.json 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_json1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.json \
    e2e_tests/diff_test_files/minimal_missing_field2.json 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the second file"
}

diff_minimal_missing_field_json2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.json \
    e2e_tests/diff_test_files/minimal_missing_field1.json 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the first file"
}

diff_minimal_missing_field_json_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.json \
    e2e_tests/diff_test_files/minimal_missing_field1.json 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_json_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.json \
    e2e_tests/diff_test_files/minimal_missing_field2.json 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_schema1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.schema \
    e2e_tests/diff_test_files/array_of_objects2.schema 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_schema2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.schema \
    e2e_tests/diff_test_files/array_of_objects1.schema 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_schema_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.schema \
    e2e_tests/diff_test_files/array_of_objects1.schema 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_schema_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.schema \
    e2e_tests/diff_test_files/array_of_objects2.schema 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_schema1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.schema \
    e2e_tests/diff_test_files/minimal_differing_types2.schema 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_schema2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.schema \
    e2e_tests/diff_test_files/minimal_differing_types1.schema 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_schema_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.schema \
    e2e_tests/diff_test_files/minimal_differing_types1.schema 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_schema_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.schema \
    e2e_tests/diff_test_files/minimal_differing_types2.schema 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_schema1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.schema \
    e2e_tests/diff_test_files/minimal_missing_field2.schema 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the second file"
}

diff_minimal_missing_field_schema2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.schema \
    e2e_tests/diff_test_files/minimal_missing_field1.schema 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the first file"
}

diff_minimal_missing_field_schema_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.schema \
    e2e_tests/diff_test_files/minimal_missing_field1.schema 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_schema_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.schema \
    e2e_tests/diff_test_files/minimal_missing_field2.schema 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_yaml1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.yaml \
    e2e_tests/diff_test_files/array_of_objects2.yaml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_yaml2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.yaml \
    e2e_tests/diff_test_files/array_of_objects1.yaml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_yaml_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.yaml \
    e2e_tests/diff_test_files/array_of_objects1.yaml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_yaml_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.yaml \
    e2e_tests/diff_test_files/array_of_objects2.yaml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_yaml1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.yaml \
    e2e_tests/diff_test_files/minimal_differing_types2.yaml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_yaml2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.yaml \
    e2e_tests/diff_test_files/minimal_differing_types1.yaml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_yaml_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.yaml \
    e2e_tests/diff_test_files/minimal_differing_types1.yaml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_yaml_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.yaml \
    e2e_tests/diff_test_files/minimal_differing_types2.yaml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_yaml1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.yaml \
    e2e_tests/diff_test_files/minimal_missing_field2.yaml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the second file"
}

diff_minimal_missing_field_yaml2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.yaml \
    e2e_tests/diff_test_files/minimal_missing_field1.yaml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the first file"
}

diff_minimal_missing_field_yaml_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.yaml \
    e2e_tests/diff_test_files/minimal_missing_field1.yaml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_yaml_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.yaml \
    e2e_tests/diff_test_files/minimal_missing_field2.yaml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_toml1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.toml \
    e2e_tests/diff_test_files/array_of_objects2.toml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_toml2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.toml \
    e2e_tests/diff_test_files/array_of_objects1.toml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'people.items.height' has differing types between the first file and the second file"
}

diff_array_of_objects_toml_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects1.toml \
    e2e_tests/diff_test_files/array_of_objects1.toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_array_of_objects_toml_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/array_of_objects2.toml \
    e2e_tests/diff_test_files/array_of_objects2.toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_toml1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.toml \
    e2e_tests/diff_test_files/minimal_differing_types2.toml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_toml2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.toml \
    e2e_tests/diff_test_files/minimal_differing_types1.toml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'age' has differing types between the first file and the second file"
}

diff_minimal_differing_types_toml_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types1.toml \
    e2e_tests/diff_test_files/minimal_differing_types1.toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_differing_types_toml_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_differing_types2.toml \
    e2e_tests/diff_test_files/minimal_differing_types2.toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_toml1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.toml \
    e2e_tests/diff_test_files/minimal_missing_field2.toml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the second file"
}

diff_minimal_missing_field_toml2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.toml \
    e2e_tests/diff_test_files/minimal_missing_field1.toml 2>&1`
    status="$?"

    expect_status='2'
    expect="the field 'missingField' is missing from the first file"
}

diff_minimal_missing_field_toml_same1() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field1.toml \
    e2e_tests/diff_test_files/minimal_missing_field1.toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

diff_minimal_missing_field_toml_same2() {
    output=`schema diff \
    e2e_tests/diff_test_files/minimal_missing_field2.toml \
    e2e_tests/diff_test_files/minimal_missing_field2.toml 2>&1`
    status="$?"

    expect_status='0'
    expect=''
}

tests=(
    "diff_array_of_objects_json1"
    "diff_array_of_objects_json2"
    "diff_array_of_objects_json_same1"
    "diff_array_of_objects_json_same2"
    "diff_minimal_differing_types_json1"
    "diff_minimal_differing_types_json2"
    "diff_minimal_differing_types_json_same1"
    "diff_minimal_differing_types_json_same2"
    "diff_minimal_missing_field_json1"
    "diff_minimal_missing_field_json2"
    "diff_minimal_missing_field_json_same1"
    "diff_minimal_missing_field_json_same2"
    "diff_array_of_objects_schema1"
    "diff_array_of_objects_schema2"
    "diff_array_of_objects_schema_same1"
    "diff_array_of_objects_schema_same2"
    "diff_minimal_differing_types_schema1"
    "diff_minimal_differing_types_schema2"
    "diff_minimal_differing_types_schema_same1"
    "diff_minimal_differing_types_schema_same2"
    "diff_minimal_missing_field_schema1"
    "diff_minimal_missing_field_schema2"
    "diff_minimal_missing_field_schema_same1"
    "diff_minimal_missing_field_schema_same2"
    "diff_array_of_objects_yaml1"
    "diff_array_of_objects_yaml2"
    "diff_array_of_objects_yaml_same1"
    "diff_array_of_objects_yaml_same2"
    "diff_minimal_differing_types_yaml1"
    "diff_minimal_differing_types_yaml2"
    "diff_minimal_differing_types_yaml_same1"
    "diff_minimal_differing_types_yaml_same2"
    "diff_minimal_missing_field_yaml1"
    "diff_minimal_missing_field_yaml2"
    "diff_minimal_missing_field_yaml_same1"
    "diff_minimal_missing_field_yaml_same2"
    "diff_array_of_objects_toml1"
    "diff_array_of_objects_toml2"
    "diff_array_of_objects_toml_same1"
    "diff_array_of_objects_toml_same2"
    "diff_minimal_differing_types_toml1"
    "diff_minimal_differing_types_toml2"
    "diff_minimal_differing_types_toml_same1"
    "diff_minimal_differing_types_toml_same2"
    "diff_minimal_missing_field_toml1"
    "diff_minimal_missing_field_toml2"
    "diff_minimal_missing_field_toml_same1"
    "diff_minimal_missing_field_toml_same2"
)
