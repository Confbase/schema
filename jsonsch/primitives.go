package jsonsch

import "fmt"

type Type string

const (
	Object  Type = "object"
	Boolean Type = "boolean"
	Array   Type = "array"
	Number  Type = "number"
	Integer Type = "integer"
	String  Type = "string"
	Null    Type = "null"
)

type Primitive struct {
	Type        Type   `json:"type"`
	Description string `json:"description,omitempty"`
}

func NewNull(params *FromExampleParams) Primitive {
	if params.NullAs == "" {
		return Primitive{Type: Null}
	}

	switch params.EmptyArraysAs {
	case "null", "nil":
		return Primitive{Type: Null}
	case "bool":
		return Primitive{Type: Boolean}
	case "string":
		return Primitive{Type: String}
	case "number", "float":
		return Primitive{Type: Number}
	case "object":
		return Primitive{Type: Object}
	default:
		return Primitive{Type: Null}
	}
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

func NewArray(data []interface{}, params *FromExampleParams) (*ArraySchema, error) {
	// TODO: incoporate entire array depending on mode
	// E.g.,
	// - use the first element to infer array type
	// - use conjuction of all elements to infer array type
	// - verify all elements are same type, otherwise fail

	var elem interface{}

	if len(data) == 0 {
		if params.EmptyArraysAs == "" {
			return nil, fmt.Errorf("cannot infer type of empty array; consider using --empty-arrays-as")
		}
		switch params.EmptyArraysAs {
		case "null", "nil":
			elem = nil
		case "bool", "boolean":
			elem = false
		case "string", "str":
			elem = ""
		case "number", "float":
			elem = 0.0
		case "object":
			elem = make(map[string]interface{})
		default:
			return nil, fmt.Errorf("invalid --empty-arrays-as value '%v'", params.EmptyArraysAs)
		}
	} else {
		elem = data[0]
	}

	a := ArraySchema{Type: Array}

	if err := buildSchema(elem, &a.Items, params); err != nil {
		return nil, err
	}

	return &a, nil
}
