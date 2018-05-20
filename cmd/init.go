// Copyright © 2018 Confbase
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

	"github.com/Confbase/schema/initcmd"
)

var initCfg initcmd.Config

var initCmd = &cobra.Command{
	Use:   "init [output instance name]",
	Short: "Initialize an instance of a schema",
	Long: `Initialize an instance of a schema.

If no schema is specified, stdin is interpreted as the schema.

Multiple instance names may be specfied.

If more than one of the (json|yaml|toml|xml|protobuf|graphql) flags are set,
behavior is undefined.

$ref fields are resolved via network requests by default. Network requests can
be avoided with the --skip-refs flag, which resolves the ref to an empty object
({}).

See the man pages for idioms, examples, and more information.`,
	Run: func(cmd *cobra.Command, args []string) {
		initcmd.Init(initCfg, args)
	},
}

func init() {
	initCmd.Flags().StringVarP(&initCfg.SchemaPath, "schema", "s", "", "specifies schema to initialize")
	initCmd.Flags().BoolVarP(&initCfg.DoJson, "json", "", false, "initialize as JSON")
	initCmd.Flags().BoolVarP(&initCfg.DoYaml, "yaml", "", false, "initialize as YAML")
	initCmd.Flags().BoolVarP(&initCfg.DoToml, "toml", "", false, "initialize as TOML")
	initCmd.Flags().BoolVarP(&initCfg.DoXml, "xml", "", false, "initialize as XML")
	initCmd.Flags().BoolVarP(&initCfg.DoProtobuf, "protobuf", "", false, "initialize as protocol buffer")
	initCmd.Flags().BoolVarP(&initCfg.DoGraphQL, "graphql", "", false, "initialize as GraphQL instance")
	initCmd.Flags().BoolVarP(&initCfg.DoPretty, "pretty", "", true, "pretty-print the output")
	initCmd.Flags().BoolVarP(&initCfg.DoPopLists, "populate-lists", "", true, "populate lists with one element")
	initCmd.Flags().BoolVarP(&initCfg.DoSkipRefs, "skip-refs", "", false, "use {} in place of $ref fields")
	RootCmd.AddCommand(initCmd)
}
