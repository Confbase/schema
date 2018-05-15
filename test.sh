#!/bin/bash

if [ "$#" -eq 1 ] && [ "$1" = '--offline' ]; then
    printf "Running in offline mode.\n"
    printf "Will skip tests which require network.\n"
    offline_mode='true'
else
    printf "Will NOT skip tests which require network.\n"
    offline_mode='false'
fi

printf "Running gofmt tests..."
gofmt_output="$(git ls-files | grep -v "^$(git ls-files -d)\$" | grep -v '^vendor/' | grep '.go$' | xargs gofmt -l 2>&1)"
if [ ! -z "$gofmt_output" ]; then
    printf "FAIL. The following files are not gofmt'd:\n$gofmt_output" 1>&2
    exit 1
fi
printf "OK\n"

printf "Running 'go install'..."
go_install_output=`go install 2>&1`
if [ ! -z "$go_install_output" ]; then
    printf "FAIL. output:\n$go_install_output" 1>&2
    exit 1
fi
printf "OK\n"

printf "Running end-to-end tests...\n"
source ./e2e_tests/lib.sh

for test_module in `ls e2e_tests/*.sh | grep -v 'lib.sh'`; do
    source "$test_module" # populates the $tests variable
    for testcase in "${tests[@]}"; do
        setup_test "$testcase"
        run_test "$testcase"
    done
done

printf "Running 'go test -v ./...'\n"
go test -v ./...
