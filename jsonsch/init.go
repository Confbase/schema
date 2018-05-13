package jsonsch

import (
	"fmt"
	"reflect"
)

// Init is the only exposed method in this file
// Init is a method on Schema which returns an
// instance of the schema.
func InitSchema(s Schema, popLists bool) (map[string]interface{}, error) {
	data := make(map[string]interface{})
	for key, value := range s.GetProperties() {

		tup, err := prop2Tuple(value, key)
		if err != nil {
			return nil, err
		}

		if err := storeTuple(tup, data, key, popLists); err != nil {
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

func storeTuple(tup tuple, dstMap map[string]interface{}, key string, popLists bool) error {
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
		childInst, err := InitSchema(childSchema, popLists)
		if err != nil {
			return err
		}
		dstMap[key] = childInst

	case Array:
		dstMap[key] = make([]interface{}, 0)
		if popLists {
			elemSchema, ok := tup.Data["items"]
			if !ok {
				return fmt.Errorf("key '%v' has type 'Array' but no 'items' field", key)
			}
			childTup, err := prop2Tuple(elemSchema, fmt.Sprintf("%v.items", key))
			if err != nil {
				return err
			}
			dstSlice, ok := dstMap[key].([]interface{})
			if !ok {
				return fmt.Errorf("type assertion failed in Array case")
			}
			newSlice, err := appendTuple(childTup, dstSlice, key)
			if err != nil {
				return err
			}
			dstMap[key] = newSlice
		}

	default:
		return fmt.Errorf("key '%v' has unrecognized 'type' field '%v'", key, tup.Type)
	}
	return nil
}

func appendTuple(tup tuple, dstSlice []interface{}, key string) ([]interface{}, error) {
	var elem interface{}

	switch tup.Type {
	case Null:
		elem = nil
	case String:
		elem = ""
	case Boolean:
		elem = false
	case Number:
		elem = 0

	case Object:
		childSchema, err := FromSchema(tup.Data, false)
		if err != nil {
			return nil, err
		}
		childInst, err := InitSchema(childSchema, true)
		if err != nil {
			return nil, err
		}
		elem = childInst

	case Array:
		elem = make([]interface{}, 0)
		elemSchema, ok := tup.Data["items"]
		if !ok {
			return nil, fmt.Errorf("key '%v' has type 'Array' but no 'items' field", key)
		}
		childTup, err := prop2Tuple(elemSchema, fmt.Sprintf("%v.items", key))
		if err != nil {
			return nil, err
		}
		childSlice, ok := elem.([]interface{})
		if !ok {
			return nil, fmt.Errorf("type assertion failed in Array case")
		}
		newSlice, err := appendTuple(childTup, childSlice, key)
		if err != nil {
			return nil, err
		}
		elem = newSlice

	default:
		return nil, fmt.Errorf("element of array at key '%v' has unrecognized 'type' field '%v'", key, tup.Type)
	}
	return append(dstSlice, elem), nil
}
