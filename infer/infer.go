package infer

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"

	"github.com/naoina/toml"
	"gopkg.in/yaml.v2"

	"github.com/Confbase/schema/jsonsch"
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
	data, err := readToMap(r)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	s := schema.New(data)
	js, err := jsonsch.FromSchema(s, cfg.DoMakeRequired)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to infer schema :/\n%v", err)
		os.Exit(1)
	}

	if err := js.Serialize(w, cfg.DoPretty); err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to serialize schema\n%v", err)
		os.Exit(1)
	}
}

func readToMap(r io.Reader) (map[string]interface{}, error) {
	// ReadAll is necessary, since the input stream could be only
	// traversable once; we must be sure to save the data
	// into a buffer on the first pass, so that we can read it
	// *multiple* times
	buf, err := ioutil.ReadAll(r)
	if err != nil {
		return nil, err
	}

	data := make(map[string]interface{})
	if err = json.Unmarshal(buf, &data); err == nil {
		return data, nil
	}

	data = make(map[string]interface{}) // be sure it's an empty map
	if err = yaml.Unmarshal(buf, &data); err == nil {
		return data, nil
	}

	data = make(map[string]interface{}) // be sure it's an empty map
	if err = toml.Unmarshal(buf, &data); err == nil {
		return data, nil
	}

	return nil, fmt.Errorf("failed to recognize input data format")
}
