package pod

import (
	"sync"

	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	v1 "k8s.io/api/core/v1"

	"github.com/kubeservice-stack/basa/src/backend/client"
	"github.com/kubeservice-stack/basa/src/backend/controllers/base"
	"github.com/kubeservice-stack/basa/src/backend/models"
	"github.com/kubeservice-stack/basa/src/backend/resources/pod"
	"github.com/kubeservice-stack/basa/src/backend/util/logs"
)

type KubePodController struct {
	base.APIController
}

func (c *KubePodController) URLMapping() {
	c.Mapping("PodStatistics", c.PodStatistics)
	c.Mapping("List", c.List)
	c.Mapping("Terminal", c.Terminal)
	c.Mapping("Create", c.Create)
	c.Mapping("Delete", c.Delete)
	c.Mapping("Get", c.Delete)
}

func (c *KubePodController) Prepare() {
	// Check administration
	c.APIController.Prepare()

	methodActionMap := map[string]string{
		"PodStatistics": models.PermissionRead,
		"List":          models.PermissionRead,
		"Get":           models.PermissionRead,
		"Terminal":      models.PermissionRead,
		"Create":        models.PermissionCreate,
		"Delete":        models.PermissionDelete,
	}
	_, method := c.GetControllerAndAction()
	c.PreparePermission(methodActionMap, method, models.PermissionTypeKubePod)
}

// @Title kubernetes pod statistics
// @Description kubernetes statistics
// @Param	cluster	query 	string	false		"the cluster "
// @Success 200 {object} models.AppCount success
func (c *KubePodController) PodStatistics() {
	cluster := c.Input().Get("cluster")
	total := 0
	countSyncMap := sync.Map{}
	countMap := make(map[string]int)
	if cluster == "" {
		managers := client.Managers()
		wg := sync.WaitGroup{}

		managers.Range(func(key, value interface{}) bool {
			manager := value.(*client.ClusterManager)
			wg.Add(1)
			go func(manager *client.ClusterManager) {
				defer wg.Done()
				count, err := pod.GetPodCounts(manager.CacheFactory)
				if err != nil {
					logs.Error("get pod counts error.", key, err)
					return
				}
				total += count
				countSyncMap.Store(manager.Cluster.Name, count)
			}(manager)
			return true
		})

		wg.Wait()
		countSyncMap.Range(func(key, value interface{}) bool {
			countMap[key.(string)] = value.(int)
			return true
		})

	} else {
		manager, err := client.Manager(cluster)
		if err == nil {
			count, err := pod.GetPodCounts(manager.CacheFactory)
			if err != nil {
				c.HandleError(err)
				return
			}
			total += count
		} else {
			c.HandleError(err)
			return
		}

	}

	c.Success(pod.PodStatistics{Total: total, Details: countMap})
}

// @Title List
// @Description find pods by resource type
// @Param	pageNo		query 	int	false		"the page current no"
// @Param	pageSize		query 	int	false		"the page size"
// @Param	name		query 	string	true		"the query resource name."
// @Success 200 {object} models.Deployment success
// @router /namespaces/:namespace/clusters/:cluster [get]
func (c *KubePodController) List() {
	cluster := c.Ctx.Input.Param(":cluster")
	namespace := c.Ctx.Input.Param(":namespace")
	resourceType := c.Input().Get("type")
	resourceName := c.Input().Get("name")
	param := c.BuildKubernetesQueryParam()
	manager := c.Manager(cluster)
	result, err := pod.GetPodListPageByType(manager.KubeClient, namespace, resourceName, resourceType, param)
	if err != nil {
		logs.Error("Get kubernetes pod by type error.", cluster, namespace, resourceType, resourceName, err)
		c.HandleError(err)
		return
	}
	c.Success(result)
}

// @Title Delete
// @Description delete the pod
// @Param	cluster		path 	string	true		"the cluster want to delete"
// @Param	namespace   path 	string	true		"the namespace want to delete"
// @Param	name		path 	string	true		"the pod name want to delete"
// @Success 200 {string} delete success!
// @router /namespaces/:namespace/clusters/:cluster [delete]
func (c *KubePodController) Delete() {
	cluster := c.Ctx.Input.Param(":cluster")
	namespace := c.Ctx.Input.Param(":namespace")
	name := c.Input().Get("name")
	cli := c.Manager(cluster)

	deletionPropagation := metaV1.DeletePropagationBackground
	err := cli.Client.CoreV1().Pods(namespace).Delete(name, &metaV1.DeleteOptions{PropagationPolicy: &deletionPropagation})

	if err != nil {
		logs.Info("Delete Pod (%s) by cluster (%s) error.%v", name, cluster, err)
		c.HandleError(err)
		return
	}

	c.Success("ok!")
}

// @Title Create
// @Description create the pod
// @Param	cluster		path 	string	true		"the cluster want to create"
// @Param	namespace   path 	string	true		"the namespace want to create"
// @Param	name		path 	string	true		"the pod name want to create"
// @Param   nodename    path   string  true        "the pod annodeName want to create"
// @Param   nodeshellimage  path   string  true        "the node shell image"
// @Success 200 return ok success
// @router /namespaces/:namespace/clusters/:cluster [post]
func (c *KubePodController) Create() {
	cluster := c.Ctx.Input.Param(":cluster")
	namespace := c.Ctx.Input.Param(":namespace")
	name := c.Input().Get("name")
	nodename := c.Input().Get("nodename")
	nodeshellimage := c.Input().Get("nodeshellimage")
	if nodeshellimage == "" {
		nodeshellimage = "docker.io/alpine:3.13"
	}
	cli := c.Manager(cluster)

	pod := &v1.Pod{}

	pod.SetName(name)
	pod.SetNamespace(namespace)

	pod.Spec.NodeName = nodename
	pod.Spec.RestartPolicy = v1.RestartPolicyAlways
	pod.Spec.TerminationGracePeriodSeconds = (func() *int64 { i := int64(0); return &i }())
	pod.Spec.HostIPC = true
	pod.Spec.HostPID = true
	pod.Spec.HostNetwork = true
	pod.Spec.Tolerations = []v1.Toleration{
		v1.Toleration{
			Operator: "Exists",
		},
	}
	pod.Spec.PriorityClassName = "system-node-critical"
	pod.Spec.Containers = []v1.Container{
		v1.Container{
			Name:  "shell",
			Image: nodeshellimage,
			SecurityContext: &v1.SecurityContext{
				Privileged: func() *bool { i := true; return &i }(),
			},
			Command: []string{"nsenter"},
			Args:    []string{"-t", "1", "-m", "-u", "-i", "-n", "sleep", "14000"},
		},
	}
	// TODO
	// set pod.Spec.ImagePullSecrets

	_, err := cli.Client.CoreV1().Pods(namespace).Create(pod)
	if err != nil {
		logs.Info("Create Pod (%s) by cluster (%s) error.%v", name, cluster, err)
		c.HandleError(err)
		return
	}

	c.Success("ok")
}

// @Title Get
// @Description find Pod by cluster
// @Param	cluster		path 	string	true		"the cluster name"
// @Param	namespace		path 	string	true		"the namespace name"
// @Success 200 {object} models.Deployment success
// @router /:pod/namespaces/:namespace/clusters/:cluster [get]
func (c *KubePodController) Get() {
	cluster := c.Ctx.Input.Param(":cluster")
	namespace := c.Ctx.Input.Param(":namespace")
	name := c.Ctx.Input.Param(":pod")
	manager := c.Manager(cluster)
	result, err := manager.Client.CoreV1().Pods(namespace).Get(name, metaV1.GetOptions{})
	if err != nil {
		logs.Info("get kubernetes Pod error.", cluster, namespace, name, err)
		c.HandleError(err)
		return
	}
	c.Success(result)
}
