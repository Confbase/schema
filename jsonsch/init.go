package jsonsch

import (
	"fmt"
	"reflect"
)

// Init is the only exposed method in this file
// Init is a method on Schema which returns an
// instance of the schema.
func InitSchema(s Schema) (map[string]interface{}, error) {
	data := make(map[string]interface{})
	for key, value := range s.GetProperties() {

		tup, err := prop2Tuple(value, key)
		if err != nil {
			return nil, err
		}

		if err := storeTuple(tup, data, key); err != nil {
			return nil, err
		}
	}
	return data, nil
}

// everything below this line is helper methods and types
type tuple struct {
	Data map[string]interface{}
	Type Type
}

func prop2Tuple(prop interface{}, key string) (tuple, error) {
	v, ok := prop.(map[string]interface{})
	if !ok {
		return tuple{}, fmt.Errorf("key '%v' has unrecognized type '%v'", key, reflect.TypeOf(prop))
	}
	vTypeInter, ok := v["type"]
	if !ok {
		return tuple{}, fmt.Errorf("key '%v' does not have 'type' field", key)
	}
	vType, ok := vTypeInter.(string)
	if !ok {
		return tuple{}, fmt.Errorf("key '%v' must 'type' field with string value", key)
	}
	return tuple{Data: v, Type: Type(vType)}, nil

}

func storeTuple(tup tuple, dstMap map[string]interface{}, key string) error {
	switch tup.Type {

	case Null:
		dstMap[key] = nil
	case String:
		dstMap[key] = ""
	case Boolean:
		dstMap[key] = false
	case Number:
		dstMap[key] = 0

	case Object:
		childSchema, err := FromSchema(tup.Data, false)
		if err != nil {
			return err
		}
		childInst, err := InitSchema(childSchema)
		if err != nil {
			return err
		}
		dstMap[key] = childInst

	case Array:
		dstMap[key] = make([]interface{}, 0)

	default:
		return fmt.Errorf("key '%v' has unrecognized 'type' field '%v'", key, tup.Type)
	}
	return nil
}
