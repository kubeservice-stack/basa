package initial

import (
	"time"

	"k8s.io/apimachinery/pkg/util/wait"

	"github.com/kubeservice-stack/basa/src/backend/client"
)

func InitClient() {
	// 定期更新client
	go wait.Forever(client.BuildApiserverClient, 5*time.Second)
}
