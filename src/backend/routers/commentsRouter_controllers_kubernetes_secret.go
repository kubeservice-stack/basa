package routers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context/param"
)

func init() {
    const KubeSecretController = "github.com/kubeservice-stack/basa/src/backend/controllers/kubernetes/secret:KubeSecretController"
    beego.GlobalControllerRouter[KubeSecretController] = append(
        beego.GlobalControllerRouter[KubeSecretController],
        beego.ControllerComments{
            Method: "Create",
            Router: `/:secretId/tpls/:tplId/clusters/:cluster`,
            AllowHTTPMethods: []string{"post"},
            MethodParams: param.Make(),
            Filters: nil,
            Params: nil,
        })
}
