package translate

import(
	"os"
	"encoding/json"
	"io"
	"io/ioutil"
	"github.com/clbanning/mxj"
    "github.com/naoina/toml"
	"gopkg.in/yaml.v2"
	"bytes"
	"fmt"
)

func TranslateEntry(cfg Config, args []string) {
	if len(args) == 0 {
		if err := Translate(os.Stdin, os.Stdout, cfg); err != nil {
			fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
	} else {
		fmt.Fprintf(os.Stderr, "error: not implemented yet\n")
		os.Exit(1)
	}
}

func Translate(r io.Reader, w io.Writer, cfg Config) error{
	m, err := readToMap(r)
	if (err != nil){
		return err;
		}
		outFmt := cfg.OutFmt()
		switch cfg.OutFmt() {
		case "json":
			enc := json.NewEncoder(w)
			if cfg.DoPretty {
				enc.SetIndent("", "    ")
			}
			if err := enc.Encode(&m); err != nil {
				return err
			}
		case "yaml":
			if err := yaml.NewEncoder(w).Encode(&m); err != nil {
				return err
			}
		case "toml":
			if err := toml.NewEncoder(w).Encode(&m); err != nil {
				return err
			}
		case "xml", "protobuf", "graphql":
			return fmt.Errorf("'%v' is not implemented yet", outFmt)
		default:
			return fmt.Errorf("unrecognized output format '%v'", outFmt)
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

	mv, err := mxj.NewMapXmlReader(bytes.NewReader(buf))
	if err == nil {
		return map[string]interface{}(mv), nil
	}

	return nil, fmt.Errorf("failed to recognize input data format")
}
