package schema

import (
	"fmt"
	"reflect"

	"github.com/Confbase/schema/jsonsch"
)

type Schema struct {
	data map[string]interface{}
}

func New(data map[string]interface{}) *Schema {
	return &Schema{data: data}
}

func (s *Schema) ToJsonSchema(doMakeRequired bool) (*jsonsch.Schema, error) {
	js := jsonsch.New()
	for key, value := range s.data {
		switch v := value.(type) {

		case map[string]interface{}:
			// value is another JSON object
			obj, err := New(v).ToJsonSchema(doMakeRequired)
			if err != nil {
				return nil, err
			}
			js.Properties[key] = obj

		case bool:
			js.Properties[key] = jsonsch.NewBoolean()
		case string:
			js.Properties[key] = jsonsch.NewString()

		case uint, uint8, uint16, uint32, uint64, float32, float64, int, int8, int16, int32, int64:
			js.Properties[key] = jsonsch.NewNumber()

		default:
			return nil, fmt.Errorf("unknown type '%v'", reflect.TypeOf(v))
		}
		if doMakeRequired {
			js.Required = append(js.Required, key)
		}
	}
	return js, nil
}
