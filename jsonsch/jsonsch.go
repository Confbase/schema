package jsonsch

import (
	"fmt"
	"strings"

	"github.com/Confbase/schema/graphqlsch"
)

type Schema interface {
	GetSchemaField() string
	SetSchemaField(string)
	GetTitle() string
	SetTitle(string)
	GetType() Type
	SetType(Type)
	GetDescription() string
	SetDescription(string)
	GetProperties() map[string]interface{}
	SetProperties(map[string]interface{})
	SetProperty(string, interface{})
	GetRequired() []string
	SetRequired([]string)
}

func ToGraphQLTypes(rootSchema Schema, rootName string) ([]graphqlsch.Type, error) {
	types := make([]graphqlsch.Type, 0)
	fields := make([]graphqlsch.Field, 0)
	for k, inter := range rootSchema.GetProperties() {
		switch value := inter.(type) {
		case Primitive:
			newFields, err := handlePrimitive(k, value, fields)
			if err != nil {
				return nil, err
			}
			fields = newFields
		case *ArraySchema:
			params := handleArraySchemaParams{
				Key:    k,
				AS:     value,
				Fields: fields,
				Types:  types,
			}
			newFields, newTypes, err := handleArraySchema(params)
			if err != nil {
				return nil, err
			}
			fields = newFields
			types = newTypes
		case Schema:
			newFields, newTypes, err := handleSchema(handleSchemaParams{
				Key:         k,
				ChildSchema: value,
				Fields:      fields,
				Types:       types,
			})
			if err != nil {
				return nil, err
			}
			fields = newFields
			types = newTypes
		default:
			return nil, fmt.Errorf("key '%v' has unexpected type %T", k, value)
		}
	}
	types = append(types, graphqlsch.NewType(rootName, fields))
	return types, nil
}

func ToGraphQLSchema(s Schema) (*graphqlsch.Schema, error) {
	title := s.GetTitle()
	if title == "" {
		title = "Object"
	}
	types, err := ToGraphQLTypes(s, title)
	if err != nil {
		return nil, err
	}
	return graphqlsch.New(types), nil
}

func handlePrimitive(key string, prim Primitive, fields []graphqlsch.Field) ([]graphqlsch.Field, error) {
	f := graphqlsch.Field{
		Name:       key,
		IsNullable: false,
		IsArray:    false,
	}
	switch prim.Type {
	case Boolean:
		f.Type = graphqlsch.Boolean
	case String:
		f.Type = graphqlsch.String
	case Number:
		f.Type = graphqlsch.Float
	case Null:
		return nil, fmt.Errorf("cannot infer type of null value (see key '%v')", key)
	default:
		return nil, fmt.Errorf("key '%v' has unexpected 'type' field value '%v'", key, prim.Type)
	}
	return append(fields, f), nil
}

type handleArraySchemaParams struct {
	Key    string
	AS     *ArraySchema
	Fields []graphqlsch.Field
	Types  []graphqlsch.Type
}

func handleArraySchema(params handleArraySchemaParams) ([]graphqlsch.Field, []graphqlsch.Type, error) {
	f := graphqlsch.Field{
		Name:       params.Key,
		IsNullable: false,
		IsArray:    true,
		ArrayDim:   1,
	}

	// unwrap multi-dimensional arrays
	item := params.AS.Items
	for {
		unwrapped, ok := item.(*ArraySchema)
		if !ok {
			break
		}
		item = unwrapped.Items
		f.ArrayDim++
	}

	// TODO: ensure all items in array are same type
	switch value := item.(type) {
	case Primitive:
		switch value.Type {
		case Boolean:
			f.Type = graphqlsch.Boolean
		case String:
			f.Type = graphqlsch.String
		case Number:
			f.Type = graphqlsch.Float
		case Null:
			return nil, nil, fmt.Errorf("cannot infer type of null value (in array at key '%v')", params.Key)
		default:
			return nil, nil, fmt.Errorf("array (key '%v') has unexpected type '%v'", params.Key, value.Type)
		}
	case Schema:
		_, newTypes, err := handleSchema(handleSchemaParams{
			Key:         params.Key,
			ChildSchema: value,
			Fields:      make([]graphqlsch.Field, 0),
			Types:       params.Types,
		})
		if err != nil {
			return nil, nil, err
		}
		params.Types = newTypes
		f.Type = graphqlsch.PrimitiveType(strings.Title(params.Key))
	default:
		return nil, nil, fmt.Errorf("key '%v' has unexpected type %T", params.Key, value)
	}

	return append(params.Fields, f), params.Types, nil
}

type handleSchemaParams struct {
	Key         string
	ChildSchema Schema
	Fields      []graphqlsch.Field
	Types       []graphqlsch.Type
}

func handleSchema(params handleSchemaParams) ([]graphqlsch.Field, []graphqlsch.Type, error) {
	childTypes, err := ToGraphQLTypes(params.ChildSchema, strings.Title(params.Key))
	if err != nil {
		return nil, nil, err
	}
	for _, childT := range childTypes {
		params.Types = append(params.Types, childT)
	}
	f := graphqlsch.Field{
		Name:       params.Key,
		Type:       graphqlsch.PrimitiveType(strings.Title(params.Key)),
		IsNullable: false,
		IsArray:    false,
	}
	return append(params.Fields, f), params.Types, nil
}
