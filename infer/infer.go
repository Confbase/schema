package infer

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"os"

	"github.com/Confbase/schema/decode"
	"github.com/Confbase/schema/example"
	"github.com/Confbase/schema/jsonsch"
)

func InferEntry(cfg Config, targets []string) {
	if len(targets) == 0 {
		if err := Infer(os.Stdin, os.Stdout, cfg); err != nil {
			fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
		return
	}

	buf, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to read from stdin\n%v", err)
		os.Exit(1)
	}

	for _, t := range targets {
		f, err := os.OpenFile(t, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0644)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to open '%v'\n%v\n", t, err)
			os.Exit(1)
		}
		defer f.Close()

		if err := Infer(bytes.NewReader(buf), f, cfg); err != nil {
			fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
	}
}

func Infer(r io.Reader, w io.Writer, cfg Config) error {
	data, err := decode.MuxDecode(r)
	if err != nil {
		return err
	}

	ex := example.New(data)
	params := jsonsch.FromExampleParams{
		DoOmitReq:     cfg.DoOmitReq,
		DoMakeReq:     cfg.DoMakeReq,
		EmptyArraysAs: cfg.EmptyArraysAs,
		NullAs:        cfg.NullAs,
	}
	js, err := jsonsch.FromExample(ex, &params)
	if err != nil {
		return fmt.Errorf("failed to infer schema\n%v", err)
	}

	js.SetSchemaField(cfg.SchemaField)

	if cfg.DoGraphQL {
		if err := jsonsch.SerializeGraphQL(js, w); err != nil {
			return fmt.Errorf("failed to serialize schema\n%v", err)
		}
	} else {
		if err := jsonsch.SerializeSchema(js, w, cfg.DoPretty); err != nil {
			return fmt.Errorf("failed to serialize schema\n%v", err)
		}
	}

	return nil
}
