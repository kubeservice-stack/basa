package initial

import (
	"github.com/astaxie/beego"

	"github.com/kubeservice-stack/basa/src/backend/util"
)

func InitKubeLabel() {
	util.AppLabelKey = beego.AppConfig.DefaultString("AppLabelKey", "basa-app")
	util.NamespaceLabelKey = beego.AppConfig.DefaultString("NamespaceLabelKey", "basa-ns")
	util.PodAnnotationControllerKindLabelKey = beego.AppConfig.DefaultString("PodAnnotationControllerKindLabelKey", "basa.cloud/controller-kind")
}
