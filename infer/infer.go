package infer

import (
	"encoding/json"
	"fmt"
	"io"
	"os"

	"github.com/Confbase/schema/schema"
)

func InferEntry(cfg Config, args []string) {
	if len(args) == 0 {
		Infer(os.Stdin, os.Stdout, cfg)
	} else {
		fmt.Fprintf(os.Stderr, "error: not implemented yet\n")
		os.Exit(1)
	}
}

func Infer(r io.Reader, w io.Writer, cfg Config) {
	var i interface{}
	if err := json.NewDecoder(r).Decode(&i); err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to parse JSON\n")
		os.Exit(1)
	}

	data, ok := i.(map[string]interface{})
	if !ok {
		fmt.Fprintf(os.Stderr, "error: data is in unrecognized format\n")
		os.Exit(1)
	}

	s := schema.New(data)
	js, err := s.ToJsonSchema(cfg.DoMakeRequired)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to infer schema :/\n")
		os.Exit(1)
	}
	if err := js.Serialize(w, cfg.DoPretty); err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to serialize schema\n%v", err)
		os.Exit(1)
	}
}
