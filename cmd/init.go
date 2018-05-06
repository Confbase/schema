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

	"github.com/Confbase/schema/initcmd"
)

var initSchemaPath string

var initCmd = &cobra.Command{
	Use:   "init <schema> [instance name]",
	Short: "Initialize an instance of a schema",
	Long: `Initialize an instance of a schema.

Multiple instance names may be specfied.`,
	Args: cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		initcmd.Init(initSchemaPath, args)
	},
}

func init() {
	initCmd.Flags().StringVarP(&initSchemaPath, "schema", "s", "", "specifies schema to init")
	RootCmd.AddCommand(initCmd)
}
