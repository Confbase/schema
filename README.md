[![Build Status](https://travis-ci.org/Confbase/schema.svg?branch=master)](https://travis-ci.org/Confbase/schema)

# schema

`schema` is a schema generator and validator tool. It supports JSON, YAML, TOML,
XML, Protobuf.

# Installation

### Static Binaries

See the Releases page for static binaries.

### Building from Source

Run `go get -u github.com/Confbase/schema`.

# Usage & FAQ

# Testing

This project has unit tests, formatting tests, and end-to-end tests.

To run unit tests, run `go test -v ./...`.

There is only one formatting test. It ensures all .go source files are gofmt'd.
Run `git ls-files | grep '.go$' | xargs gofmt -l` to list all non-gofmt'd files
in your local branch.

The end-to-end tests require bash.

To run all tests (unit, formatting, and end-to-end), execute `./test.sh`.

# Contributing

See CONTRIBUTING.md.
