// Copyright © 2018 Thomas Fischer <thomas@confbase.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"github.com/spf13/cobra"

	"github.com/Confbase/schema/infer"
)

var inferCfg infer.Config

var inferCmd = &cobra.Command{
	Use:   "infer [path]",
	Short: "Infer and output schemas from example data",
	Long: `Infer and output schemas from example data.

By default, JSON schema (see https://json-schema.org) is output.

GraphQL schemas can be output with the --graphql flag. The --omit-required
and --schema-field flags do nothing when used with the --graphql flag.

If called with no arguments, 'schema infer' reads from stdin and writes the
inferred schema to stdout.

If called with arguments, each argument is interpreted as a file path. The 
schema for each path is inferred and written to a new file of the same path, 
but with its basename prefixed with the string 'schema.'. For example,

$ schema config1.json config2.json

will write the inferred schemas to schema.config1.json and schema.config2.json,
respectively.

See the man pages for idioms, examples, and more information.`,
	Run: func(cmd *cobra.Command, args []string) {
		infer.InferEntry(inferCfg, args)
	},
}

func init() {
	inferCmd.Flags().BoolVarP(&inferCfg.DoPretty, "pretty", "p", true, "pretty-print the output")
	inferCmd.Flags().BoolVarP(&inferCfg.DoMakeRequired, "make-required", "r", false, "make all fields required")
	inferCmd.Flags().BoolVarP(&inferCfg.DoOmitRequired, "omit-required", "", true, "omit 'required' field if it's empty")
	inferCmd.Flags().BoolVarP(&inferCfg.DoGraphQL, "graphql", "g", false, "output GraphQL schemas")
	inferCmd.Flags().StringVarP(&inferCfg.SchemaField, "schema-field", "s", "", "specifies the value of the $schema field")
	RootCmd.AddCommand(inferCmd)
}
