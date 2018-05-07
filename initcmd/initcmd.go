package initcmd

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/Confbase/schema/jsonsch"
)

func Init(schemaPath string, targets []string) {

	var data map[string]interface{}
	if schemaPath == "" {
		if err := json.NewDecoder(os.Stdin).Decode(&data); err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to parse data from stdin as JSON\n%v\n", err)
			os.Exit(1)
		}
	} else {
		f, err := os.Open(schemaPath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to open '%v'\n%v\n", schemaPath, err)
			os.Exit(1)
		}
		defer f.Close()

		if err := json.NewDecoder(f).Decode(&data); err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to parse '%v' as JSON\n%v\n", schemaPath, err)
			os.Exit(1)
		}
	}
	js, err := jsonsch.FromSchema(data)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: input JSON is not a valid schema\n%v\n", err)
		os.Exit(1)
	}

	if len(targets) == 0 {
		instance, err := js.Init()
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to initialize instance of schema\n%v\n", err)
			os.Exit(1)
		}
		if err := jsonsch.SerializeInstance(instance, os.Stdout, true); err != nil {
			fmt.Fprintf(os.Stderr, "error: failed to serialize instance of schema\n%v\n", err)
			os.Exit(1)
		}
	} else {
		for _, t := range targets {
			f, err := os.OpenFile(t, os.O_RDWR|os.O_CREATE, 0666)
			if err != nil {
				fmt.Fprintf(os.Stderr, "error: failed to open '%v'\n%v\n", t, err)
				os.Exit(1)
			}
			defer f.Close()

			instance, err := js.Init()
			if err != nil {
				fmt.Fprintf(os.Stderr, "error: failed to initialize instance of schema\n%v\n", err)
				os.Exit(1)
			}
			if err := jsonsch.SerializeInstance(instance, f, true); err != nil {
				fmt.Fprintf(os.Stderr, "error: failed to serialize instance of schema\n%v\n", err)
				os.Exit(1)
			}
		}
	}
}
