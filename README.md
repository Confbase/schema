[![Build Status](https://travis-ci.org/Confbase/schema.svg?branch=master)](https://travis-ci.org/Confbase/schema)

`schema` is a schema generator and validator tool.

A common use is to generate [JSON Schema](https://json-schema.org) from
arbirtrary JSON, YAML, TOML, XML, Protobuf.

# Installation

### Static Binaries

See the Releases page for static binaries.

### Building from Source

Run `go get -u github.com/Confbase/schema`.

# Usage & FAQ

Run `schema -h` or `schema --help` to view the usage.

### How do I infer the schema of arbitrary JSON/YAML/TOML/XML?

Pipe it into `schema infer`. The data format is discovered automatically. Example:

```
$ printf '{"name":"Thomas","color":"blue"}' | schema infer
{
    "title": "",
    "type": "object",
    "properties": {
        "color": {
            "type": "string"
        },
        "name": {
            "type": "string"
        }
    },
    "required": []
}
```

Another example:

```
$ schema infer
addr: 0.0.0.0
port: 5001
^D
{
    "title": "",
    "type": "object",
    "properties": {
        "addr": {
            "type": "string"
        },
        "port": {
            "type": "number"
        }
    },
    "required": []
}
```

### How do I make fields required in inferred schema?

Use `--make-required`. If specified with no arguments, all fields will be
required. Example:

```
$ printf '{"name":"Thomas","color":"blue"}' | schema infer --make-required
{
    "title": "",
    "type": "object",
    "properties": {
        "color": {
            "type": "string"
        },
        "name": {
            "type": "string"
        }
    },
    "required": [
        "name",
        "color"
    ]
}
```

### How do I generate compact schemas?

Disable pretty-printing with `--pretty=false`. Example:

```
$ printf '{"name":"Thomas","color":"blue"}' | schema infer --pretty=false
{"title":"","type":"object","properties":{"color":{"type":"string"},"name":{"type":"string"}},"required":[]}
```

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
