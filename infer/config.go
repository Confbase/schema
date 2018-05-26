package infer

type Config struct {
	DoPretty      bool
	DoMakeReq     bool
	DoOmitReq     bool
	DoGraphQL     bool
	SchemaField   string
	EmptyArraysAs string
	NullAs        string
}
