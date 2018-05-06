package schema

type Schema struct {
	Data map[string]interface{}
}

func New(data map[string]interface{}) *Schema {
	return &Schema{Data: data}
}
