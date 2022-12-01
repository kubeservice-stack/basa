package version

import (
	"github.com/kubeservice-stack/basa/src/backend/controllers/base"
	"github.com/kubeservice-stack/basa/src/backend/models"
	"github.com/kubeservice-stack/basa/src/backend/resources/version"
	"github.com/kubeservice-stack/basa/src/backend/util/logs"
)

type KubeVersionController struct {
	base.APIController
}

func (c *KubeVersionController) URLMapping() {
	c.Mapping("Get", c.Get)
}

func (c *KubeVersionController) Prepare() {
	// Check administration
	c.APIController.Prepare()

	methodActionMap := map[string]string{
		"Get": models.PermissionRead,
	}
	_, method := c.GetControllerAndAction()
	c.PreparePermission(methodActionMap, method, models.PermissionTypeKubeService)
}

// @Title GetDetail
// @Description find kubernetes/kubelets version by cluster
// @Param	cluster		path 	string	true		"the cluster name"
// @Success 200 {object} version.ClusterVersion success
// @router /clusters/:cluster [get]
func (c *KubeVersionController) Get() {
	cluster := c.Ctx.Input.Param(":cluster")
	manager := c.Manager(cluster)
	verisonDetail, err := version.GetClusterVersionDetail(manager.Client)
	if err != nil {
		logs.Error("get kubernetes(%s) detail error: %s", cluster, err.Error())
		c.AbortInternalServerError("get kubernetes/kubelets version detail error.")
	}
	c.Success(verisonDetail)
}
