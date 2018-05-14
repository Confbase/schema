package jsonsch

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func ReplaceRefs(data map[string]interface{}, doSkipRefs bool) error {

	var subData map[string]interface{}
	keyPath := make([]string, 0)
	stack := make([][]string, 0)
	stack = append(stack, keyPath)

	for len(stack) > 0 {
		keyPath := stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		next, err := subDataFrom(data, keyPath)
		if err != nil {
			return err
		}
		subData = next

		refInter, ok := subData["$ref"]
		if !ok {
			newStack, isTypeObject, err := pushPropsToStack(data, stack, keyPath)
			if err != nil {
				return err
			}
			if !isTypeObject {
				continue
			}
			stack = newStack
			continue
		}
		refStr, ok := refInter.(string)
		if !ok {
			return fmt.Errorf("'$ref' field must be a string")
		}
		if doSkipRefs {
			delete(subData, "$ref")
			subData["type"] = string(Object)
			subData["properties"] = make(map[string]interface{})
			if err := setDataAtKeyPath(data, subData, keyPath); err != nil {
				return err
			}
			continue
		}
		resp, err := http.Get(refStr)
		if err != nil {
			return err
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return fmt.Errorf("received %v status code", resp.StatusCode)
		}
		var refData map[string]interface{}
		if err := json.NewDecoder(resp.Body).Decode(&refData); err != nil {
			return err
		}
		subData = refData
		if err := setDataAtKeyPath(data, subData, keyPath); err != nil {
			return err
		}
		stack = append(stack, keyPath)
	}
	return nil
}

// returns stack, isTypeObject, error
func pushPropsToStack(data map[string]interface{}, stack [][]string, prefix []string) ([][]string, bool, error) {
	subData, err := subDataFrom(data, prefix)
	if err != nil {
		return stack, false, err
	}

	typeInter, ok := subData["type"]
	if !ok {
		return stack, false, nil
	}
	typeStr, ok := typeInter.(string)
	if !ok {
		return nil, true, fmt.Errorf("'type' field is not a string")
	}
	if typeStr != string(Object) {
		return stack, false, nil
	}

	propsInter, ok := subData["properties"]
	if !ok {
		return nil, true, fmt.Errorf("'properties' field does not exist")
	}
	props, ok := propsInter.(map[string]interface{})
	if !ok {
		return nil, true, fmt.Errorf("'properties' field is not a map[string]interface{}")
	}
	for k, _ := range props {
		keyPath := append([]string(nil), prefix...)
		keyPath = append(keyPath, "properties", k)
		stack = append(stack, keyPath)
	}
	return stack, true, nil
}

func subDataFrom(data map[string]interface{}, keyPath []string) (map[string]interface{}, error) {
	subData := data
	for len(keyPath) > 0 {
		key := keyPath[0]
		if len(keyPath) == 1 {
			keyPath = keyPath[:0]
		} else {
			keyPath = keyPath[1:len(keyPath)]
		}
		nextInter, ok := subData[key]
		if !ok {
			return nil, fmt.Errorf("invalid key path")
		}
		next, ok := nextInter.(map[string]interface{})
		if !ok {
			return nil, fmt.Errorf("invalid type in key path; expected map[string]interface")
		}
		subData = next
	}
	return subData, nil
}

func setDataAtKeyPath(data, srcData map[string]interface{}, keyPath []string) error {
	if len(keyPath) < 1 {
		data = srcData
		return nil
	}
	if len(keyPath) == 1 {
		data[keyPath[0]] = srcData
		return nil
	}
	nextInter, ok := data[keyPath[0]]
	if !ok {
		return fmt.Errorf("invalid key path")
	}
	next, ok := nextInter.(map[string]interface{})
	if !ok {
		return fmt.Errorf("invalid type in key path; expected map[string]interface")
	}
	return setDataAtKeyPath(next, srcData, keyPath[1:len(keyPath)])
}
