<p align="center">
    <img src="images/schema_logo_circle_transparent.png" style="max-width: 150px;" />
</p>

[![Build Status](https://travis-ci.org/Confbase/schema.svg?branch=master)](https://travis-ci.org/Confbase/schema)

**schema** is a schema generator, instantiator, and validator tool.

Common uses cases:

* infer [JSON Schema](https://json-schema.org) from arbirtrary JSON,
GraphQL schemas, protobuf schemas, YAML, TOML, and XML.

```
$ curl https://mystartup.io/my/json/endpoint | schema infer
{
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
```

* `schema infer` automatically detects the format of the incoming data, so
there's no need to specify whether it is JSON, YAML, TOML, etc.

```
$ cat config.yaml | schema infer --make-required
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
    "required": ["addr", "port"]
}
```

* instantiate JSON, GraphQL queries, protocol buffers, YAML, TOML, and XML
from inferred schemas.

```
$ # assume the output of the previous example was written to the file my_schema
$ cat my_schema | schema init
{
    "age": 0,
    "name": ""
}
```

* instantiate in a specific format

```
$ cat my_schema | schema init --yaml
age: 0
name: ''
```

* instantiate with random values

```
$ cat my_schema | schema init --random
{
    "age": -2921.198,
    "name": "lOIslkjf"
}
```


# Installation

See the Releases page for static binaries.

Run `go get -u github.com/Confbase/schema` to build from source.

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

The end-to-end tests require bash.

To run all tests (unit, formatting, and end-to-end), execute `./test.sh`.

# Contributing

See CONTRIBUTING.md.
