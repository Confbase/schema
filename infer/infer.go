package infer

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
)

func Infer(args []string) {
	if len(args) == 0 {
		infer(os.Stdin, os.Stdout)
	} else {
		fmt.Fprintf(os.Stderr, "error: not implemented yet\n")
		os.Exit(1)
	}
}

func infer(r io.Reader, w io.Writer) {
	var i interface{}
	if err := json.NewDecoder(r).Decode(&i); err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to parse JSON\n")
		os.Exit(1)
	}
	if err := json.NewEncoder(w).Encode(&i); err != nil {
		fmt.Fprintf(os.Stderr, "error: failed to write JSON to stdout\n")
		os.Exit(1)
	}
}
