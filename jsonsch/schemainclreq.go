package jsonsch

import "sort"

type SchemaInclReq struct {
	SchemaField string                 `json:"$schema,omitempty"`
	Title       string                 `json:"title"`
	Type        Type                   `json:"type"`
	Description string                 `json:"description,omitempty"`
	Properties  map[string]interface{} `json:"properties"`
	Required    []string               `json:"required"`
}

func NewInclReq() *SchemaInclReq {
	return &SchemaInclReq{
		Type:       Object,
		Properties: make(map[string]interface{}),
		Required:   make([]string, 0),
	}
}

func (s *SchemaInclReq) SetRequired(r []string) {
	s.Required = append(r)
	sort.Strings(s.Required)
}

func (s *SchemaInclReq) GetRequired() []string {
	return s.Required
}

func (s *SchemaInclReq) SetProperty(k string, v interface{}) {
	s.Properties[k] = v
}

func (s *SchemaInclReq) SetProperties(ps map[string]interface{}) {
	s.Properties = ps
}

func (s *SchemaInclReq) GetProperties() map[string]interface{} {
	return s.Properties
}

func (s *SchemaInclReq) SetDescription(d string) {
	s.Description = d
}

func (s *SchemaInclReq) GetDescription() string {
	return s.Description
}

func (s *SchemaInclReq) SetType(t Type) {
	s.Type = t
}

func (s *SchemaInclReq) GetType() Type {
	return s.Type
}

func (s *SchemaInclReq) SetTitle(t string) {
	s.Title = t
}

func (s *SchemaInclReq) GetTitle() string {
	return s.Title
}

func (s *SchemaInclReq) SetSchemaField(sf string) {
	s.SchemaField = sf
}

func (s *SchemaInclReq) GetSchemaField() string {
	return s.SchemaField
}
