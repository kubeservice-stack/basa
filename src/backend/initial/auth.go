package initial

import (
	_ "github.com/kubeservice-stack/basa/src/backend/controllers/auth/db"
	_ "github.com/kubeservice-stack/basa/src/backend/controllers/auth/ldap"
	_ "github.com/kubeservice-stack/basa/src/backend/controllers/auth/oauth2"
	_ "github.com/kubeservice-stack/basa/src/backend/oauth2"
)
