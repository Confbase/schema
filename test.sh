#!/bin/bash

printf "Running gofmt tests..."
gofmt_output=`git ls-files | grep '.go$' | xargs gofmt -l`
if [ ! -z "$gofmt_output" ]; then
    printf "FAIL. The following files are not gofmt'd:\n$gofmt_output" 1>&2
    exit 1
fi
printf "OK\n"

printf "Running end-to-end tests...\n"
source ./e2e_tests/lib.sh

test_modules=`ls e2e_tests/*.sh | grep -v 'lib.sh'`
for test_module in "$test_modules"; do
    source "$test_module" # populates the $tests variable
    for testcase in "${tests[@]}"; do
        run_test "$testcase"
    done
done

printf "Running 'go test -v ./...'\n"
go test -v ./...
