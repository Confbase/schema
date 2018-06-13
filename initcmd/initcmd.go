package initcmd

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/Confbase/schema/decode"
	"github.com/Confbase/schema/jsonsch"
)

func Init(cfg Config, targets []string) {

	var data map[string]interface{}
	if cfg.SchemaPath == "" {
		if err := json.NewDecoder(os.Stdin).Decode(&data); err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to parse data ")
			fmt.Fprintf(os.Stderr, "from stdin as JSON\n%v\n", err)
			os.Exit(1)
		}
	} else {
		f, err := os.Open(cfg.SchemaPath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to open ")
			fmt.Fprintf(os.Stderr, "'%v'\n%v\n", cfg.SchemaPath, err)
			os.Exit(1)
		}
		defer f.Close()

		if err := json.NewDecoder(f).Decode(&data); err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to parse ")
			fmt.Fprintf(os.Stderr, "'%v' as JSON\n%v\n", cfg.SchemaPath, err)
			os.Exit(1)
		}
	}
	js, err := jsonsch.FromSchema(data, cfg.DoSkipRefs)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: input JSON is not a valid schema\n%v\n", err)
		os.Exit(1)
	}

	if len(targets) == 0 {
		inst, err := jsonsch.InitSchema(js, cfg.DoPopLists, cfg.DoRandom)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to initialize ")
			fmt.Fprintf(os.Stderr, "instance of schema\n%v\n", err)
			os.Exit(1)
		}
		err = decode.DemuxEncode(os.Stdout, inst, cfg.OutFmt(), cfg.DoPretty)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to serialize instance ")
			fmt.Fprintf(os.Stderr, "of schema\n%v\n", err)
			os.Exit(1)
		}
		return
	}

	for _, t := range targets {
		f, err := os.OpenFile(t, os.O_RDWR|os.O_CREATE, 0666)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to open '%v'\n%v\n", t, err)
			os.Exit(1)
		}
		defer f.Close()

		inst, err := jsonsch.InitSchema(js, cfg.DoPopLists, cfg.DoRandom)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to initialize instance of ")
			fmt.Fprintf(os.Stderr, "schema\n%v\n", err)
			os.Exit(1)
		}
		err = decode.DemuxEncode(f, inst, cfg.OutFmt(), cfg.DoPretty)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to serialize instance of ")
			fmt.Fprintf(os.Stderr, "schema\n%v\n", err)
			os.Exit(1)
		}
	}
}
