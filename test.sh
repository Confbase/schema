#!/bin/sh

printf "Running gofmt tests..."
gofmt_output=`git ls-files | grep '.go$' | xargs gofmt -l`
if [ ! -z "$gofmt_output" ]; then
    printf "FAIL. The following files are not gofmt'd:\n$gofmt_output" 1>&2
    exit 1
fi
printf "OK\n"

printf "Running 'go test -v ./...'\n"
go test -v ./...
