package jsonsch

import (
	"encoding/json"
	"io"

	"github.com/Confbase/schema/graphqlsch"
)

func SerializeSchema(s Schema, w io.Writer, doPretty bool) error {
	enc := json.NewEncoder(w)
	if doPretty {
		enc.SetIndent("", "    ")
	}
	if err := enc.Encode(&s); err != nil {
		return err
	}
	return nil
}

func SerializeGraphQL(s Schema, w io.Writer) error {
	gqls, err := ToGraphQLSchema(s)
	if err != nil {
		return err
	}
	return graphqlsch.SerializeSchema(gqls, w)
}
