// generate init data sql, for manual init db
package main

import (
	"fmt"

	"github.com/kubeservice-stack/basa/src/backend/database/initial"
)

func main() {
	for _, data := range initial.InitialData {
		fmt.Println(data)
	}
}
