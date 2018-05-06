package jsonsch

import (
	"encoding/json"
	"fmt"
	"io"
	"reflect"

	"github.com/Confbase/schema/schema"
)

type Type string

const (
	Object  Type = "object"
	Boolean Type = "boolean"
	Array   Type = "array"
	Number  Type = "number"
	String  Type = "string"
)

type Schema struct {
	Title      string                 `json:"title"`
	Type       Type                   `json:"type"`
	Properties map[string]interface{} `json:"properties"`
	Required   []string               `json:"required"`
}

func New() *Schema {
	return &Schema{
		Type:       Object,
		Properties: make(map[string]interface{}),
		Required:   make([]string, 0),
	}
}

func (s *Schema) Serialize(w io.Writer, doPretty bool) error {
	enc := json.NewEncoder(w)
	if doPretty {
		enc.SetIndent("", "    ")
	}
	if err := enc.Encode(&s); err != nil {
		return err
	}
	return nil
}

func FromSchema(s *schema.Schema, doMakeRequired bool) (*Schema, error) {
	js := New()
	for key, value := range s.Data {
		switch v := value.(type) {

		case map[string]interface{}:
			// value is another JSON object
			obj, err := FromSchema(schema.New(v), doMakeRequired)
			if err != nil {
				return nil, err
			}
			js.Properties[key] = obj

		case bool:
			js.Properties[key] = NewBoolean()
		case string:
			js.Properties[key] = NewString()

		case uint, uint8, uint16, uint32, uint64, int, int8, int16, int32, int64, float32, float64:
			js.Properties[key] = NewNumber()

		case []interface{}:
			arr, err := NewArray(v, doMakeRequired)
			if err != nil {
				return nil, err
			}
			js.Properties[key] = arr

		default:
			return nil, fmt.Errorf("unknown type '%v'", reflect.TypeOf(v))
		}
		if doMakeRequired {
			js.Required = append(js.Required, key)
		}
	}
	return js, nil
}

type Primitive struct {
	Type Type `json:"type"`
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

	// set a.Items
	switch v := data[0].(type) {
	case bool:
		a.Items = NewBoolean()
	case string:
		a.Items = NewString()

	case uint, uint8, uint16, uint32, uint64, int, int8, int16, int32, int64, float32, float64:
		a.Items = NewNumber()

	case map[string]interface{}:
		// value is another JSON object
		obj, err := FromSchema(schema.New(v), doMakeRequired)
		if err != nil {
			return nil, err
		}
		a.Items = obj

	default:
		return nil, fmt.Errorf("unknown type '%v'", reflect.TypeOf(v))
	}

	return &a, nil
}
