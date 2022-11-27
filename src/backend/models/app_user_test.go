package models_test

import (
	"testing"

	"github.com/kubeservice-stack/basa/src/backend/models"
)

func TestGetUserListByAppId(t *testing.T) {
	data, err := models.AppUserModel.GetUserListByAppId(1)
	if err != nil {
		t.Error(err)
	}
	for _, app := range data {
		t.Log(app.User.Name, app.Group)
	}
}
