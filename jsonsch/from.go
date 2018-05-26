package jsonsch

import (
	"fmt"

	"github.com/Confbase/schema/example"
)

func FromSchema(data map[string]interface{}, doOmitReq, doSkipRefs bool) (Schema, error) {
	var js Schema
	if doOmitReq {
		js = NewOmitReq()
	} else {
		js = NewInclReq()
	}

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
	js.SetProperties(properties)

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

type FromExampleParams struct {
	DoOmitReq     bool
	DoMakeReq     bool
	EmptyArraysAs string
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
