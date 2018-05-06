package initcmd

import (
	"fmt"
	"os"
)

func Init(schemaPath string, targets []string) {
	fmt.Println(schemaPath, targets)
	os.Exit(0)
}
