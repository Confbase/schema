package jsonsch

import (
	"encoding/json"
	"io"
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

/*
func SerializeInstance(inst map[string]interface{}, w io.Writer, outFmt string, doPretty bool) error {
	switch outFmt {
	case "json":
		enc := json.NewEncoder(w)
		if doPretty {
			enc.SetIndent("", "    ")
		}
		if err := enc.Encode(&inst); err != nil {
			return err
		}
	case "yaml":
		if err := yaml.NewEncoder(w).Encode(&inst); err != nil {
			return err
		}
	case "toml":
		if err := toml.NewEncoder(w).Encode(&inst); err != nil {
			return err
		}
	case "xml", "protobuf", "graphql":
		return fmt.Errorf("'%v' is not implemented yet", outFmt)
	default:
		return fmt.Errorf("unrecognized output format '%v'", outFmt)
	}
	return nil
}
*/
