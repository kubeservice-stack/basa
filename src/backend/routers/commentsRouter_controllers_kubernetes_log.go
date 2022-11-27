package routers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context/param"
)

func init() {
    const KubeLogController = "github.com/kubeservice-stack/basa/src/backend/controllers/kubernetes/log:KubeLogController"
    beego.GlobalControllerRouter[KubeLogController] = append(
        beego.GlobalControllerRouter[KubeLogController],
        beego.ControllerComments{
            Method: "List",
            Router: `/:pod/containers/:container/namespaces/:namespace/clusters/:cluster`,
            AllowHTTPMethods: []string{"get"},
            MethodParams: param.Make(),
            Filters: nil,
            Params: nil,
        })
}
