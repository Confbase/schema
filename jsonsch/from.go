package jsonsch

import (
	"fmt"

	"github.com/Confbase/schema/example"
)

func FromSchema(data map[string]interface{}, doSkipRefs bool) (Schema, error) {
	var js Schema
	js = NewInclReq()

	if err := ReplaceRefs(data, doSkipRefs); err != nil {
		return nil, err
	}

	// type field
	typeInter, ok := data["type"]
	if !ok {
		return nil, fmt.Errorf("'type' field does not exist")
	}
	jsType, ok := typeInter.(string)
	if !ok {
		return nil, fmt.Errorf("'type' field must be a string")
	}
	js.SetType(Type(jsType))

	// properties field
	propsInter, ok := data["properties"]
	if !ok {
		return nil, fmt.Errorf("'properties' field does not exist")
	}
	properties, ok := propsInter.(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("'properties' field must be an object")

	}
	for k, v := range properties {
		propObj, ok := v.(map[string]interface{})
		if !ok {
			return nil, fmt.Errorf("'properties' field must only contain objects")
		}

		subSchema, err := fromSchema(propObj, k)
		if err != nil {
			return nil, err
		}
		js.SetProperty(k, subSchema)

	}

	if reqInter, ok := data["required"]; ok {
		wrongType := false
		strSlice := make([]string, 0)
		interSlice, ok := reqInter.([]interface{})
		if ok {
			for _, v := range interSlice {
				if s, isStr := v.(string); isStr {
					strSlice = append(strSlice, s)
				} else {
					wrongType = false
					break
				}
			}
		}
		if !ok || wrongType {
			return nil, fmt.Errorf("'required' field must be an array of strings")
		}
		js.SetRequired(strSlice)
	}
	if titleInter, ok := data["title"]; ok {
		if title, ok := titleInter.(string); ok {
			js.SetTitle(title)
		} else {
			return nil, fmt.Errorf("'title' field must be a string")
		}
	}
	if descInter, ok := data["description"]; ok {
		if description, ok := descInter.(string); ok {
			js.SetDescription(description)
		} else {
			return nil, fmt.Errorf("'description' field must be a string")
		}
	}

	return js, nil
}

// fromSchema takes a map[string]interface{} and returns a
// jsonsch-Typed schema object. The `k` field is not optional
// and only used in error messages.
func fromSchema(propObj map[string]interface{}, k string) (interface{}, error) {
	tInter, ok := propObj["type"]
	if !ok {
		return nil, fmt.Errorf("field '%v' does not have a 'type' field", k)
	}
	tStr, ok := tInter.(string)
	if !ok {
		return nil, fmt.Errorf("field '%v' has a 'type' field, but it's not a string", k)
	}

	params := FromExampleParams{
		DoOmitReq:     false,
		DoMakeReq:     false,
		EmptyArraysAs: "",
		NullAs:        "",
	}

	switch Type(tStr) {
	case Null:
		return NewNull(&params), nil
	case Boolean:
		return NewBoolean(), nil
	case String:
		return NewString(), nil

	case Number, "integer", "float":
		return NewNumber(), nil

	case Array:
		itemsInter, ok := propObj["items"]
		if !ok {
			return nil, fmt.Errorf("key '%v' has 'type' field of value '%v', but no 'items' field", k, Array)
		}
		items, ok := itemsInter.(map[string]interface{})
		if !ok {
			return nil, fmt.Errorf("key '%v' has 'items' field, but it's not a map[string]interface{}", k)
		}
		arr, err := fromSchema(items, fmt.Sprintf("%v.items", k))
		if err != nil {
			return nil, err
		}
		return NewArray(arr), nil

	case Object:
		// value is another JSON object
		obj, err := FromSchema(propObj, true)
		if err != nil {
			return nil, err
		}
		return obj, nil

	default:
		return nil, fmt.Errorf("unknown type '%v'", tStr)
	}

}

type FromExampleParams struct {
	DoOmitReq     bool
	DoMakeReq     bool
	EmptyArraysAs string
	NullAs        string
}

func FromExample(ex *example.Example, params *FromExampleParams) (Schema, error) {
	var js Schema
	if params.DoOmitReq {
		js = NewOmitReq()
	} else {
		js = NewInclReq()
	}

	for key, value := range ex.Data {
		var childDst interface{}
		if err := buildSchema(value, &childDst, params); err != nil {
			return nil, err
		}
		js.SetProperty(key, childDst)

		if params.DoMakeReq {
			js.SetRequired(append(js.GetRequired(), key))
		}
	}
	return js, nil
}
