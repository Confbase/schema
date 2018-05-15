package infer

import (
	"fmt"
	"io"
	"os"

	"github.com/Confbase/schema/example"
	"github.com/Confbase/schema/jsonsch"
	"github.com/Confbase/schema/util"
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
	data, err := util.MuxDecode(r)
	if err != nil {
		return err
	}

	ex := example.New(data)
	js, err := jsonsch.FromExample(ex, cfg.DoOmitRequired, cfg.DoMakeRequired)
	if err != nil {
		return fmt.Errorf("failed to infer schema :/\n%v", err)
	}

	js.SetSchemaField(cfg.SchemaField)

	if err := jsonsch.SerializeSchema(js, w, cfg.DoPretty); err != nil {
		return fmt.Errorf("failed to serialize schema\n%v", err)
	}

	return nil
}
