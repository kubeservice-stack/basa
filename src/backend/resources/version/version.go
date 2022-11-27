package version

import (
	"github.com/pkg/errors"
	"k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	apimachineryversionutil "k8s.io/apimachinery/pkg/util/version"
	"k8s.io/client-go/kubernetes"
)

type ClusterVersion struct {
	// kubernetesVersion describes the version of the Kubernetes API Server, Controller Manager, Scheduler and Proxy.
	KubernetesVersion string `json:"kubernetesVersion"`
	// KubeletVersions is a map with a version number linked to the amount of kubelets running that version in the cluster
	KubeletVersions map[string]uint16 `json:"kubeletVersions"`
}

func (c *ClusterVersion) kubernetesVersion(cli *kubernetes.Clientset) (string, *apimachineryversionutil.Version, error) {
	clusterVersionInfo, err := cli.Discovery().ServerVersion()
	if err != nil {
		return "", nil, errors.Wrap(err, "Couldn't fetch cluster version from the API Server")
	}

	clusterVersion, err := apimachineryversionutil.ParseSemantic(clusterVersionInfo.String())
	if err != nil {
		return "", nil, errors.Wrap(err, "Couldn't parse cluster version")
	}
	return clusterVersionInfo.String(), clusterVersion, nil
}

func (c *ClusterVersion) kubeletVersions(cli *kubernetes.Clientset) (map[string]uint16, error) {
	nodes, err := cli.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		return nil, errors.New("couldn't list all nodes in cluster")
	}
	return computeKubeletVersions(nodes.Items), nil
}

func computeKubeletVersions(nodes []v1.Node) map[string]uint16 {
	kubeletVersions := map[string]uint16{}
	for _, node := range nodes {
		kver := node.Status.NodeInfo.KubeletVersion
		if _, found := kubeletVersions[kver]; !found {
			kubeletVersions[kver] = 1
			continue
		}
		kubeletVersions[kver]++
	}
	return kubeletVersions
}

func GetClusterVersionDetail(cli *kubernetes.Clientset) (*ClusterVersion, error) {
	cv := &ClusterVersion{}
	clusterVersionStr, _, err := cv.kubernetesVersion(cli)
	if err != nil {
		return nil, err
	}
	cv.KubernetesVersion = clusterVersionStr
	kubeletVersions, err := cv.kubeletVersions(cli)
	if err != nil {
		return nil, err
	}
	cv.KubeletVersions = kubeletVersions
	return cv, nil
}
