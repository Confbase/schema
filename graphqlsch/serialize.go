package graphqlsch

import (
	"fmt"
	"io"
	"strings"
)

func SerializeSchema(s *Schema, w io.Writer) error {
	strs := make([]string, 0)
	for _, t := range s.Types {
		strs = append(strs, t.ToString())
	}
	fmt.Fprintf(w, "%v", strings.Join(strs, "\n\n"))
	return nil
}
