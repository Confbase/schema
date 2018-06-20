package graphqlsch

import (
	"fmt"
	"strings"
)

type Schema struct {
	Types []Type
}

func New(types []Type) *Schema {
	return &Schema{Types: types}
}

type Type struct {
	Name   string
	Fields []Field
}

func NewType(name string, fields []Field) Type {
	return Type{
		Name:   name,
		Fields: fields,
	}
}

func (t Type) ToString() string {
	lines := make([]string, 0)
	lines = append(lines, fmt.Sprintf("type %v {", t.Name))
	for _, f := range t.Fields {
		lines = append(lines, f.ToString())
	}
	lines = append(lines, "}")
	return strings.Join(lines, "\n")
}

type Field struct {
	Name           string
	Type           PrimitiveType
	IsNullable     bool
	IsArray        bool
	IsElemNullable bool
	ArrayDim       uint
}

func (f Field) ToString() string {
	var typeStr string
	if f.IsArray {
		if f.IsElemNullable {
			typeStr = fmt.Sprintf("%v", f.Type)
		} else {
			typeStr = fmt.Sprintf("%v!", f.Type)
		}
		for level := uint(0); level < f.ArrayDim; level++ {
			typeStr = fmt.Sprintf("[%v]", typeStr)
		}
	} else {
		typeStr = fmt.Sprintf("%v", f.Type)
	}
	if !f.IsNullable {
		typeStr = fmt.Sprintf("%v!", typeStr)
	}
	return fmt.Sprintf("    %v: %v", f.Name, typeStr)
}

type PrimitiveType string

const (
	String  PrimitiveType = "String"
	Int     PrimitiveType = "Int"
	Float   PrimitiveType = "Float"
	Boolean PrimitiveType = "Boolean"
	ID      PrimitiveType = "ID"
)
