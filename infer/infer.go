package infer

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"

	"github.com/naoina/toml"
	"gopkg.in/yaml.v2"

	"github.com/Confbase/schema/example"
	"github.com/Confbase/schema/jsonsch"
)

func InferEntry(cfg Config, args []string) {
	if len(args) == 0 {
		if err := Infer(os.Stdin, os.Stdout, cfg); err != nil {
			fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
	} else {
		fmt.Fprintf(os.Stderr, "error: not implemented yet\n")
		os.Exit(1)
	}
}

func Infer(r io.Reader, w io.Writer, cfg Config) error {
	data, err := readToMap(r)
	if err != nil {
		return err
	}

	ex := example.New(data)
	js, err := jsonsch.FromExample(ex, cfg.DoMakeRequired)
	if err != nil {
		return fmt.Errorf("failed to infer schema :/\n%v", err)
	}

	if err := js.Serialize(w, cfg.DoPretty); err != nil {
		return fmt.Errorf("failed to serialize schema\n%v", err)
	}

	return nil
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
