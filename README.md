<p align="center">
    <img src="images/schema_logo_circle_transparent.png" width="150px" />
</p>

[![Build Status](https://travis-ci.org/Confbase/schema.svg?branch=master)](https://travis-ci.org/Confbase/schema) [![Go Report Card](https://goreportcard.com/badge/github.com/Confbase/schema)](https://goreportcard.com/report/github.com/Confbase/schema)

# Table of Contents

* [Introduction](#introduction)
* [Installation](#installation)
* [FAQ](#faq)
* [Testing](#testing)
* [Contributing](#contributing)

# Introduction

**schema** is a schema generator, instantiator, and validator tool.

Common uses cases:

* Infer [GraphQL](https://graphql.org) schemas from arbirtrary JSON, YAML,
TOML, and XML:

```
$ curl http://piedpiper.tld/some_endpoint | schema infer --graphql
type People {
    age: Float!
    name: String!
}

type Object {
    people: [People!]!
}
```

* Omit `--graphql` to get [JSON Schema](https://json-schema.org):

```
$ curl http://piedpiper.tld/some_endpoint | schema infer
{
    "title": "",
    "type": "object",
    "properties": {
        "people": {
            "type": "array",
            "items": {
                "title": "",
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string"
                    },
                    "age": {
                        "type": "number"
                    }
                }
            }
        }
    }
}
```

* `schema infer` automatically detects the format of the incoming data, so
there's no need to specify whether it is JSON, YAML, TOML, etc.:

```
$ cat config.yaml | schema infer
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
    }
}
```

* Instantiate JSON, GraphQL queries, protocol buffers, YAML, TOML, and XML
from inferred schemas:

```
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

# Installation

See the Releases page for static binaries.

Run `go get -u github.com/Confbase/schema` to build from source.

# FAQ

* [How do I infer GraphQL schemas from data with null values?](#how-do-i-infer-graphql-schemas-from-data-with-null-values)
* [How do I make fields required in inferred schemas?](#how-do-i-make-fields-required-in-inferred-schemas)
* [How do I generate compact schemas?](#how-do-i-generate-compact-schemas)
* [Why am I getting the error 'toml: cannot marshal nil interface {}'?](#why-am-i-getting-the-error-toml-cannot-marshal-nil-interface)
* [What is the behavior of inferring and translating XML?](#what-is-the-behavior-of-inferring-and-translating-xml)
* [How do I initialize empty lists?](#how-do-i-initialize-empty-lists)
* [Where is the `$schema` field in inferred schemas?](#where-is-the-schema-field-in-inferred-schemas)

### How do I infer GraphQL schemas from data with null values?

There are a few different approaches which solve this problem.

The most laborious---but also the safest---approach is to manually replace
null values with non-null values before inferring the schema.

There are two approaches which are quicker, but more prone to error.

If your data has one field per line, you could remove all lines with the string
"null", then manually add the fields which were omitted. *Warning*: This is
prone to errors. Specifically, in addition to all fields with null values being
omitted, all fields whose names contain the string "null" will be omitted as
well.

```
$ cat my_data.json | grep -v 'null' | schema infer --graphql
```

Another approach is to replace the string "null" with the empty string "". This
means the fields with null values will now have the type `String` in the
inferred schema. *Warning*: Fields whose names contain the string "null" will
be clobbered.

```
$ cat my_data.yaml | sed 's/null/""/g' | schema infer --graphql
```

### How do I make fields required in inferred schemas?

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

Use `--omit-required=false` to always include the 'required' field in the
inferred schema, even if it is an empty array:

```
$ printf '{"name":"Thomas","color":"blue"}' | schema infer --omit-required=false
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

### How do I generate compact schemas?

Disable pretty-printing with `--pretty=false`. Example:

```
$ printf '{"name":"Thomas","color":"blue"}' | schema infer --pretty=false
{"title":"","type":"object","properties":{"color":{"type":"string"},"name":{"type":"string"}}}
```

### Why am I getting the error 'toml: cannot marshal nil interface {}'?

Currently, toml does not support nil/null values. See
[this issue on the toml GitHub page](https://github.com/toml-lang/toml/issues/30).

### What is the behavior of inferring and translating XML?

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
$ cat example.xml | schema translate --yaml
note:
  body: Don't forget me this weekend!
  from: Jani
  heading: Reminder
  to: Tove
```

**WARNING**: Here is an example of where the mapping fails:

```
$ schema translate --xml
{}
^D
<doc/>
$ schema translate --xml | schema translate --json
{}
^D
{
    "doc": ""
}
```

As demonstrated by the example above, there are inputs **X** such that
translating **X** from format **F** to XML and back to format **F** gives an
output not equal to **X**. In the example, an empty JSON object (`{}`) was
translated to XML and then translated back to JSON. The resulting JSON
(`{"doc":""}`) is clearly not an empty object.

**WARNING**: All type information is lost in XML.

For example:

```
$ schema translate --xml | schema translate --json
{"height": 6.0, "isAcadian": true}
{
    "doc": {
        "height": "6",
        "isAcadian": "true"
    }
}
```

All values are interpreted as strings.

### How do I initialize empty lists?

By default, `schema init` will initialize one element of each list. To
initialize empty lists instead, use the flag `--populate-lists=false`.
Example:


```
$ cat schema.json | schema init --populate-lists=false
{
    "truthinesses": []
}
```

Compared to the default behavior:

```
$ cat schema.json | schema init
{
    "truthinesses": [
        false
    ]
}
```

### Where is the `$schema` field in inferred schemas?

The `$schema` field can be specified with the `--schema-field` (short form `-s`)
flag.

Example:

```
$ cat my_data.json | schema infer -s 'http://json-schema.org/draft-06/schema'
{
    "$schema": "http://json-schema.org/draft-06/schema",
    "title": "",
    "type": "object",
    "properties": {
        "name": {
            "type": "string"
        }
    }
}
```

# Testing

This project has unit tests, formatting tests, and end-to-end tests.

To run unit tests, run `go test -v ./...`.

There is only one formatting test. It ensures all .go source files are gofmt'd.

The end-to-end tests require bash and an internet connection. To skip tests
which require an internet connection, run with the `--offline` flag:
`./test_all --offline`.

To run all tests (unit, formatting, and end-to-end), execute `./test_all`.

# Contributing

Issues and pull requests are welcome. If you are making a significant
contribution (more than fixing a typo), add your name to the "Contributors"
section in your PR.

### Contributors

* [Thomas Fischer](https://github.com/thomasdfischer)
* [Ish Shah](https://github.com/theishshah)
* [Victor Niu](https://github.com/lathie)
* [Noah Mullen](https://github.com/HoobMD)
