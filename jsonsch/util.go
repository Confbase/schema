package jsonsch

import (
	"fmt"
	"reflect"

	"github.com/Confbase/schema/example"
)

func buildSchema(fromValue interface{}, dst *interface{}, doMakeRequired bool) error {
	switch v := fromValue.(type) {
	case nil:
		*dst = NewNull()
	case bool:
		*dst = NewBoolean()
	case string:
		*dst = NewString()

	case uint, uint8, uint16, uint32, uint64, int, int8, int16, int32, int64, float32, float64:
		*dst = NewNumber()

	case []interface{}:
		arr, err := NewArray(v, doMakeRequired)
		if err != nil {
			return err
		}
		*dst = arr

	case map[string]interface{}:
		// value is another JSON object
		obj, err := FromExample(example.New(v), doMakeRequired)
		if err != nil {
			return err
		}
		*dst = obj

	case map[interface{}]interface{}:
		obj, err := interInterMap2Sch(v, doMakeRequired)
		if err != nil {
			return err
		}
		*dst = obj

	default:
		return fmt.Errorf("unknown type '%v'", reflect.TypeOf(v))
	}
	return nil
}

func interInterMap2Sch(v map[interface{}]interface{}, doMakeRequired bool) (*Schema, error) {
	if len(v) == 0 {
		return nil, fmt.Errorf("cannot infer type of empty map")
	}

	data := make(map[string]interface{})
	for vKey, vValue := range v {
		dataKey, ok := vKey.(string)
		if !ok {
			return nil, fmt.Errorf("unrecognized map key type '%v'", reflect.TypeOf(vKey))
		}
		data[dataKey] = vValue
	}

	return FromExample(example.New(data), doMakeRequired)
}
