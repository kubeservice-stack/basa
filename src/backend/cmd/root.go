package cmd

import (
	"github.com/astaxie/beego"

	"github.com/kubeservice-stack/basa/src/backend/initial"
	_ "github.com/kubeservice-stack/basa/src/backend/routers"
	"github.com/kubeservice-stack/basa/src/backend/workers/webhook"
)

func Run() {

	// MySQL
	initial.InitDb()

	// Swagger API
	if beego.BConfig.RunMode == "dev" {
		beego.BConfig.WebConfig.DirectoryIndex = true
		beego.BConfig.WebConfig.StaticDir["/swagger"] = "swagger"
	}

	// K8S Client
	initial.InitClient()

	// 初始化RsaPrivateKey
	initial.InitRsaKey()

	busEnable := beego.AppConfig.DefaultBool("BusEnable", false)
	if busEnable {
		initial.InitBus()
	}

	webhook.RegisterHookHandler()

	// init kube labels
	initial.InitKubeLabel()

	beego.Run()
}
