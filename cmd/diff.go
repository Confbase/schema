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
	Short: "Output the difference between two schemas",
	Long:  `Outputs the difference between two schemas.`,
	Args:  cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		diffCfg.Schema1, diffCfg.Schema2 = args[0], args[1]
		diff.Entry(&diffCfg)
	},
}

func init() {
	rootCmd.AddCommand(diffCmd)
}
