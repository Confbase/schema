package infer

type Config struct {
	DoPretty       bool
	DoMakeRequired bool
	DoOmitRequired bool
	DoGraphQL      bool
	SchemaField    string
}
