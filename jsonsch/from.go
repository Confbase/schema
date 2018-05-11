package jsonsch

import (
	"fmt"

	"github.com/Confbase/schema/example"
)

func FromSchema(data map[string]interface{}, doOmitRequired bool) (Schema, error) {
	var js Schema
	if doOmitRequired {
		js = NewOmitReq()
	} else {
		js = NewInclReq()
	}

	if typeInter, ok := data["type"]; ok {
		if jsType, ok := typeInter.(string); ok {
			js.SetType(Type(jsType))
		} else {
			return nil, fmt.Errorf("'type' field must be a string")
		}
	} else {
		return nil, fmt.Errorf("'type' field does not exist")
	}

	if propsInter, ok := data["properties"]; ok {
		if properties, ok := propsInter.(map[string]interface{}); ok {
			js.SetProperties(properties)
		} else {
			return nil, fmt.Errorf("'properties' field must be an object")
		}
	} else {
		return nil, fmt.Errorf("'properties' field does not exist")
	}

	if reqInter, ok := data["required"]; ok {
		if req, ok := reqInter.([]string); ok {
			js.SetRequired(req)
		} else if req, ok := reqInter.([]interface{}); !ok || len(req) > 0 {
			return nil, fmt.Errorf("'required' field must be an array of strings")
		}
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

func FromExample(ex *example.Example, doOmitRequired, doMakeRequired bool) (Schema, error) {
	var js Schema
	if doOmitRequired {
		js = NewOmitReq()
	} else {
		js = NewInclReq()
	}

	for key, value := range ex.Data {
		var childDst interface{}
		if err := buildSchema(value, &childDst, doOmitRequired, doMakeRequired); err != nil {
			return nil, err
		}
		js.SetProperty(key, childDst)

		if doMakeRequired {
			js.SetRequired(append(js.GetRequired(), key))
		}
	}
	return js, nil
}
