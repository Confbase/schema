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
	Short: "Infer schema from example data and output schema file",
	Long: `Infer schema from example data and output schema file.

OVERVIEW

If called with no arguments, 'schema infer' reads from stdin and writes the
inferred schema to stdout.

If called with arguments, each argument is interpreted as a file path. The 
schema for each path is inferred and written to a new file of the same path, 
but with its basename prefixed with the string 'schema.'. For example,

$ schema config1.json config2.json

will write the inferred schemas to schema.config1.json and schema.config2.json,
respectively.

COMMON MISTAKES

TOML does not support nil/null values. 'schema infer' will not create schemas
with null values. This has implications for the commonly-used idiom

$ cat sample_data.json | schema infer | schema init --toml

Since the input stream---'sample_data.json'---is JSON, it could contain null
values. In turn, a schema with null values could be inferred and piped to
'schema init --toml'. However, 'schema init --toml' will fail immediately
upon encountering null values, since TOML does not support them.

---

There is no well-defined mapping between XML and key-value stores. Despite this,
schema still provides some support for inferring the schema of XML. schema uses
the library github.com/clbanning/mxj. Users can expect the behavior of schema's
infer command to match the behavior of github.com/clbanning/mxj's
NewMapXmlReader function when parsing XML.`,
	Run: func(cmd *cobra.Command, args []string) {
		infer.InferEntry(inferCfg, args)
	},
}

func init() {
	inferCmd.Flags().BoolVarP(&inferCfg.DoPretty, "pretty", "p", true, "pretty-print the output")
	inferCmd.Flags().BoolVarP(&inferCfg.DoMakeRequired, "make-required", "r", false, "make all fields required")
	RootCmd.AddCommand(inferCmd)
}
