package jsonsch

type SchemaOmitReq struct {
	SchemaField string                 `json:"$schema,omitempty"`
	Title       string                 `json:"title"`
	Type        Type                   `json:"type"`
	Description string                 `json:"description,omitempty"`
	Properties  map[string]interface{} `json:"properties"`
	Required    []string               `json:"required,omitempty"`
}

func NewOmitReq() *SchemaOmitReq {
	return &SchemaOmitReq{
		Type:       Object,
		Properties: make(map[string]interface{}),
		Required:   make([]string, 0),
	}
}

func (s *SchemaOmitReq) SetRequired(r []string) {
	s.Required = r
}

func (s *SchemaOmitReq) GetRequired() []string {
	return s.Required
}

func (s *SchemaOmitReq) SetProperty(k string, v interface{}) {
	s.Properties[k] = v
}

func (s *SchemaOmitReq) SetProperties(ps map[string]interface{}) {
	s.Properties = ps
}

func (s *SchemaOmitReq) GetProperties() map[string]interface{} {
	return s.Properties
}

func (s *SchemaOmitReq) SetDescription(d string) {
	s.Description = d
}

func (s *SchemaOmitReq) GetDescription() string {
	return s.Description
}

func (s *SchemaOmitReq) SetType(t Type) {
	s.Type = t
}

func (s *SchemaOmitReq) GetType() Type {
	return s.Type
}

func (s *SchemaOmitReq) SetTitle(t string) {
	s.Title = t
}

func (s *SchemaOmitReq) GetTitle() string {
	return s.Title
}

func (s *SchemaOmitReq) SetSchemaField(sf string) {
	s.SchemaField = sf
}

func (s *SchemaOmitReq) GetSchemaField() string {
	return s.SchemaField
}
