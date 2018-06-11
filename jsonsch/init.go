package jsonsch

import (
	"fmt"
	"math/rand"
	"reflect"
)

// InitSchema is the only exposed method in this file
// InitSchema is a method on Schema which returns an
// instance of the schema.
//
// InitSchema assumes all $ref fields are already either
// 1) resolved and replaced by a network request
// 2) replaced by an empty object
func InitSchema(s Schema, doPopLists, doRandom bool) (map[string]interface{}, error) {
	data := make(map[string]interface{})
	for key, value := range s.GetProperties() {
		initValue, err := initSchema(value, doPopLists, doRandom, key)
		if err != nil {
			return nil, err
		}
		data[key] = initValue
	}
	return data, nil
}

func initSchema(schema interface{}, doPopLists, doRandom bool, k string) (interface{}, error) {
	switch v := schema.(type) {
	case Primitive:
		if doRandom {
			return initRandomPrimitive(v.Type, k)
		}
		return initPrimitive(v.Type, k)
	case ArraySchema:
		return initArray(v, doPopLists, doRandom, k)
	case Schema:
		return InitSchema(v, doPopLists, doRandom)
	default:
		return nil, fmt.Errorf("key '%v' has unrecognized type '%v'", k, reflect.TypeOf(schema))
	}
}

func initPrimitive(t Type, k string) (interface{}, error) {
	switch t {
	case Null:
		return nil, nil
	case String:
		return "", nil
	case Boolean:
		return false, nil
	case Integer, Number:
		return 0, nil
	default:
		return nil, fmt.Errorf("key '%v' (primitive) has unrecognized type '%v'", k, t)
	}
}

func initRandomPrimitive(t Type, k string) (interface{}, error) {
	switch t {
	case Null:
		return nil, nil
	case String:
		return randomString(), nil
	case Boolean:
		return rand.Intn(2) != 0, nil
	case Integer, Number:
		return rand.Int(), nil
	default:
		return nil, fmt.Errorf("key '%v' (primitive) has unrecognized type '%v'", k, t)
	}
}

func initArray(as ArraySchema, doPopLists, doRandom bool, k string) (interface{}, error) {
	arr := make([]interface{}, 0)
	if doPopLists {
		elem, err := initSchema(as.Items, doPopLists, doRandom, k)
		if err != nil {
			return nil, err
		}
		arr = append(arr, elem)
	}
	return arr, nil
}
