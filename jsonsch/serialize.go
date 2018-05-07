package jsonsch

import (
	"encoding/json"
	"io"
)

func (s *Schema) Serialize(w io.Writer, doPretty bool) error {
	enc := json.NewEncoder(w)
	if doPretty {
		enc.SetIndent("", "    ")
	}
	if err := enc.Encode(&s); err != nil {
		return err
	}
	return nil
}

func SerializeInstance(inst map[string]interface{}, w io.Writer, doPretty bool) error {
	enc := json.NewEncoder(w)
	if doPretty {
		enc.SetIndent("", "    ")
	}
	if err := enc.Encode(&inst); err != nil {
		return err
	}
	return nil
}
