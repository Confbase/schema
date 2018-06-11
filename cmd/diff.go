// Copyright © 2018 Thomas Fischer
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

	"github.com/Confbase/schema/diff"
)

var diffCfg diff.Config
var diffCmd = &cobra.Command{
	Use:   "diff",
	Short: "Output the structural differences between two files",
	Long: `Outputs the structural differences between two schemas or files.

If the files are both JSON schemas, they are interpreted as such and type
differences between the schemas are output.

Otherwise, their schemas are inferred and the differences between the inferred
schemas are output.

There are two types of differences:

    1. A field is included in one schema but missing from the other
    2. A field is in both schemas, but the type in each schema is not the same`,
	Args: cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		diffCfg.Schema1, diffCfg.Schema2 = args[0], args[1]
		diff.Entry(&diffCfg)
	},
}

func init() {
	rootCmd.AddCommand(diffCmd)
	diffCmd.Flags().StringVarP(&diffCfg.MissFrom1, "title-1", "1", "", "title of first schema")
	diffCmd.Flags().StringVarP(&diffCfg.MissFrom2, "title-2", "2", "", "title of second schema")
	diffCmd.Flags().BoolVarP(&diffCfg.DoSkipRefs, "skip-refs", "", false, "do not resolve $ref fields with a network request")
}
