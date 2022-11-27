package routers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context/param"
)

func init() {
	const KubeVersionController = "github.com/kubeservice-stack/basa/src/backend/controllers/kubernetes/version:KubeVersionController"
	beego.GlobalControllerRouter[KubeVersionController] = append(
		beego.GlobalControllerRouter[KubeVersionController],
		beego.ControllerComments{
			Method:           "Get",
			Router:           `/clusters/:cluster`,
			AllowHTTPMethods: []string{"get"},
			MethodParams:     param.Make(),
			Filters:          nil,
			Params:           nil,
		})
}
