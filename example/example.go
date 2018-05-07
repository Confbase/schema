package example

type Example struct {
	Data map[string]interface{}
}

func New(data map[string]interface{}) *Example {
	return &Example{Data: data}
}
