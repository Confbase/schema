package jsonsch

import "fmt"

type Type string

const (
	Object  Type = "object"
	Boolean Type = "boolean"
	Array   Type = "array"
	Number  Type = "number"
	String  Type = "string"
	Null    Type = "null"
)

type Schema struct {
	Title       string                 `json:"title"`
	Type        Type                   `json:"type"`
	Description string                 `json:"description,omitempty"`
	Properties  map[string]interface{} `json:"properties"`
	Required    []string               `json:"required"`
}

func New() *Schema {
	return &Schema{
		Type:       Object,
		Properties: make(map[string]interface{}),
		Required:   make([]string, 0),
	}
}

type Primitive struct {
	Type        Type   `json:"type"`
	Description string `json:"description,omitempty"`
}

func NewNull() Primitive {
	return Primitive{Type: Null}
}

func NewBoolean() Primitive {
	return Primitive{Type: Boolean}
}

func NewNumber() Primitive {
	return Primitive{Type: Number}
}

func NewString() Primitive {
	return Primitive{Type: String}
}

type ArraySchema struct {
	Type  Type        `json:"type"`
	Items interface{} `json:"items"`
}

func NewArray(data []interface{}, doMakeRequired bool) (*ArraySchema, error) {
	// TODO: incoporate entire array depending on mode
	// E.g.,
	// - use the first element to infer array type
	// - use conjuction of all elements to infer array type
	// - verify all elements are same type, otherwise fail
	// - have some default value for when arrays are empty
	if len(data) == 0 {
		return nil, fmt.Errorf("cannot infer type of empty array")
	}

	a := ArraySchema{Type: Array}

	if err := buildSchema(data[0], &a.Items, doMakeRequired); err != nil {
		return nil, err
	}

	return &a, nil
}
