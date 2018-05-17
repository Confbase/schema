package jsonsch

import (
	"fmt"
	"math/rand"
	"time"
)

const randAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-=_+[]{};':/?,.<>"
const randStrMaxLen = 64

func init() {
	rand.Seed(time.Now().Unix())
}

func generateRandomString(length int) string {
	randStr := make([]byte, length)
	for i := range randStr {
		randStr[i] = randAlphabet[rand.Intn(len(randAlphabet))]
	}
	return string(randStr)
}

func storeRandomTuple(tup tuple, dstMap map[string]interface{}, key string, doPopLists bool) error {
	rand.Seed(time.Now().Unix())

	switch tup.Type {

	case Null:
		dstMap[key] = nil
	case String:
		dstMap[key] = generateRandomString(rand.Int() % randStrMaxLen)
	case Boolean:
		dstMap[key] = rand.Intn(2) != 0
	case Integer, Number:
		dstMap[key] = rand.Int()

	case Object:
		childSchema, err := FromSchema(tup.Data, false, true)
		if err != nil {
			return err
		}
		childInst, err := InitSchema(childSchema, doPopLists, true)
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
			newSlice, err := appendRandomTuple(childTup, dstSlice, key)
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

func appendRandomTuple(tup tuple, dstSlice []interface{}, key string) ([]interface{}, error) {
	var elem interface{}

	rand.Seed(time.Now().Unix())

	switch tup.Type {

	case Null:
		elem = nil
	case String:
		elem = generateRandomString(rand.Int() % randStrMaxLen)
	case Boolean:
		elem = rand.Intn(2) != 0
	case Integer, Number:
		elem = rand.Int()

	case Object:
		childSchema, err := FromSchema(tup.Data, false, true)
		if err != nil {
			return nil, err
		}
		childInst, err := InitSchema(childSchema, true, true)
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
		newSlice, err := appendRandomTuple(childTup, childSlice, key)
		if err != nil {
			return nil, err
		}
		elem = newSlice

	default:
		return nil, fmt.Errorf("element of array at key '%v' has unrecognized 'type' field '%v'", key, tup.Type)
	}
	return append(dstSlice, elem), nil
}
