package apiserver

//noinspection ALL
import (
	"github.com/astaxie/beego"
	"github.com/spf13/cobra"

	"github.com/kubeservice-stack/basa/src/backend/initial"
	_ "github.com/kubeservice-stack/basa/src/backend/routers"
	"github.com/kubeservice-stack/basa/src/backend/workers/webhook"
)

var (
	APIServerCmd = &cobra.Command{
		Use:    "apiserver",
		PreRun: preRun,
		Run:    run,
	}
)

func preRun(cmd *cobra.Command, args []string) {
}

func run(cmd *cobra.Command, args []string) {
	// MySQL
	initial.InitDb()

	// Swagger API
	if beego.BConfig.RunMode == "dev" {
		beego.BConfig.WebConfig.DirectoryIndex = true
		beego.BConfig.WebConfig.StaticDir["/swagger"] = "swagger"
	}

	// K8S Client
	initial.InitClient()

	// 初始化RabbitMQ
	busEnable := beego.AppConfig.DefaultBool("BusEnable", false)
	if busEnable {
		initial.InitBus()
	}
	// register webhook event handler
	hookenable := beego.AppConfig.DefaultBool("EnableWebhook", false)
	if hookenable {
		webhook.RegisterHookHandler()
	}

	// 初始化RsaPrivateKey
	initial.InitRsaKey()

	// init kube labels
	initial.InitKubeLabel()

	beego.Run()
}
