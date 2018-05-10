<p align="center">
    <img src="images/schema_logo_circle_transparent.png" width="150px" />
</p>

[![Build Status](https://travis-ci.org/Confbase/schema.svg?branch=master)](https://travis-ci.org/Confbase/schema)

# Table of Contents

* [Introduction](#introduction)
* [Installation](#installation)
* [FAQ](#faq)
* [Testing](#testing)
* [Contributing](#contributing)

# Introduction

**schema** is a schema generator, instantiator, and validator tool.

Common uses cases:

* Infer [JSON Schema](https://json-schema.org) from arbirtrary JSON,
GraphQL schemas, protobuf schemas, YAML, TOML, and XML:

```
$ curl https://example.com/json_endpoint | schema infer
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
there's no need to specify whether it is JSON, YAML, TOML, etc.:

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

* Instantiate JSON, GraphQL queries, protocol buffers, YAML, TOML, and XML
from inferred schemas:

```
$ # assume the output of the previous example was written to the file my_schema
$ cat my_schema | schema init
{
    "age": 0,
    "name": ""
}
```

* Instantiate in a specific format:

```
$ cat my_schema | schema init --yaml
age: 0
name: ""
```

* Another Example:

```
$ cat my_schema | schema init --toml
age = 0
name = ""
```

* Instantiate with random values:

```
$ cat my_schema | schema init --random
{
    "age": -2921.198,
    "name": "lOIslkjf"
}
```

* Show the structure of a large file:

Suppose you have a massive JSON object and you want to see the structure of it,
without all the values. Infer the schema and then initialize an instance.
Example:

```
$ cat LEA-x.json
{
  "name": "Limited Edition Alpha",
  "code": "LEA",
  "gathererCode": "1E",
  "magicCardsInfoCode": "al",
  "releaseDate": "1993-08-05",
  "border": "black",
  "type": "core",
  "booster": [
    "rare",
    "uncommon",
    "uncommon",
    "uncommon",
    "common",
    "common",
...
...
(and on, and on, and on...)
```

It will be cumbersome to read through the file to understand how the JSON is
structured. Instead, infer the schema and initialize an instance with default
values:

```
$ cat ~/LEA-x.json | schema infer | schema init
{
    "booster": [],
    "border": "",
    "cards": [],
    "code": "",
    "gathererCode": "",
    "magicCardsInfoCode": "",
    "mkm_id": 0,
    "mkm_name": "",
    "name": "",
    "releaseDate": "",
    "type": ""
}
```

Nice!

# Installation

See the Releases page for static binaries.

Run `go get -u github.com/Confbase/schema` to build from source.

# FAQ

* [How do I make fields required in inferred schema?](#how-do-i-make-fields-required-in-inferred-schema)
* [How do I generate compact schemas?](#how-do-i-generate-compact-schemas)
* [Why am I getting the error 'toml: cannot marshal nil interface {}'?](#why-am-i-getting-the-error-toml-cannot-marshal-nil-interface-)
* [What is the behavior of inferring schemas from XML?](#what-is-the-behavior-of-inferring-schemas-from-xml)

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

### Why am I getting the error 'toml: cannot marshal nil interface {}'?

Currently, toml does not support nil/null values. See
[this issue on the toml GitHub page](https://github.com/toml-lang/toml/issues/30).

### What is the behavior of inferring schemas from XML?

There is no well-defined mapping between XML and key-value stores. Despite this,
schema still provides some support for inferring the schema of XML. schema uses
the library github.com/clbanning/mxj. Users can expect the behavior of schema's
infer command to match the behavior of github.com/clbanning/mxj's
NewMapXmlReader function when parsing XML.

To give an idea of this behavior, consider this example:

```
$ cat example.xml
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
$ cat example.xml | schema infer | schema init --yaml
note:
  body: ""
  from: ""
  heading: ""
  to: ""
```

# Testing

This project has unit tests, formatting tests, and end-to-end tests.

To run unit tests, run `go test -v ./...`.

There is only one formatting test. It ensures all .go source files are gofmt'd.

The end-to-end tests require bash.

To run all tests (unit, formatting, and end-to-end), execute `./test.sh`.

# Contributing

Issues and pull requests are welcome.
