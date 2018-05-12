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

	"github.com/Confbase/schema/translate"
)

var translateCfg translate.Config

// translateCmd represents the translate command
var translateCmd = &cobra.Command{
	Use:   "translate",
	Short: "translate input data into another format",
	Long: `Translate input data into another format.

If no input file is specified, stdin is used as input.

Multiple output paths may be specfied. If none are specified, translated data
is written to stdout.

If more than one of the (json|yaml|toml|xml|protobuf|graphql) flags are set,
behavior is undefined.`,
	Run: func(cmd *cobra.Command, args []string) {
		translate.TranslateEntry(translateCfg, args)
	},
}

func init() {
	translateCmd.Flags().StringVarP(&translateCfg.InputPath, "input", "i", "", "path to input data to translate")
	translateCmd.Flags().BoolVarP(&translateCfg.DoJson, "json", "", false, "initialize as JSON")
	translateCmd.Flags().BoolVarP(&translateCfg.DoYaml, "yaml", "", false, "initialize as YAML")
	translateCmd.Flags().BoolVarP(&translateCfg.DoToml, "toml", "", false, "initialize as TOML")
	translateCmd.Flags().BoolVarP(&translateCfg.DoXml, "xml", "", false, "initialize as XML")
	translateCmd.Flags().BoolVarP(&translateCfg.DoProtobuf, "protobuf", "", false, "initialize as protocol buffer")
	translateCmd.Flags().BoolVarP(&translateCfg.DoGraphQL, "graphql", "", false, "initialize as GraphQL instance")
	translateCmd.Flags().BoolVarP(&translateCfg.DoPretty, "pretty", "", true, "pretty-print the output")
	RootCmd.AddCommand(translateCmd)
}
