package jsonsch

import (
	"fmt"
	"reflect"
)

// InitSchema is the only exposed method in this file
// InitSchema is a method on Schema which returns an
// instance of the schema.
//
// InitSchema assumes all $ref fields are already either
// 1) resolved and replaced by a network request
// 2) replaced by an empty object
func InitSchema(s Schema, doPopLists bool, doRandom bool) (map[string]interface{}, error) {
	data := make(map[string]interface{})
	for key, value := range s.GetProperties() {

		tup, err := prop2Tuple(value, key)
		if err != nil {
			return nil, err
		}

		if doRandom {
			if err := storeRandomTuple(tup, data, key, doPopLists); err != nil {
				return nil, err
			}
		} else {
			if err := storeTuple(tup, data, key, doPopLists); err != nil {
				return nil, err
			}
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
		return tuple{}, fmt.Errorf("key '%v' must have 'type' field with string value", key)
	}
	return tuple{Data: v, Type: Type(vType)}, nil

}

func storeTuple(tup tuple, dstMap map[string]interface{}, key string, doPopLists bool) error {
	switch tup.Type {

	case Null:
		dstMap[key] = nil
	case String:
		dstMap[key] = ""
	case Boolean:
		dstMap[key] = false
	case Integer, Number:
		dstMap[key] = 0

	case Object:
		childSchema, err := FromSchema(tup.Data, false, true)
		if err != nil {
			return err
		}
		childInst, err := InitSchema(childSchema, doPopLists, false)
		if err != nil {
			return err
		}
		dstMap[key] = childInst

	case Array:
		dstMap[key] = make([]interface{}, 0)
		if doPopLists {
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
		childSchema, err := FromSchema(tup.Data, false, true)
		if err != nil {
			return nil, err
		}
		childInst, err := InitSchema(childSchema, true, false)
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
