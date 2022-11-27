.PHONY: run-backend run-worker run-frontend syncdb release

MAKEFLAGS += --warn-undefined-variables

# Build variables
REGISTRY_URI :=docker.io/dongjiang1989/
RELEASE_VERSION :=$(shell git describe --always --tags)
UI_BUILD_VERSION :=v1.0.0
SERVER_BUILD_VERSION :=v1.0.0

update-version:
	./hack/updateversion.sh

# run module
run-backend:
	cd src/backend/ && go run main.go

run-frontend:
	cd src/frontend/ && npm start

# dev
syncdb:
	go run src/backend/database/syncdb.go orm syncdb

sqlall:
	mkdir -p _dev
	go run src/backend/database/syncdb.go orm sqlall > _dev/basa.sql

initdata:
	mkdir -p _dev
	go run src/backend/database/generatedata/main.go > _dev/basa-data.sql

swagger-openapi:
	cd src/backend && swagger generate spec -o ./swagger/openapi.swagger.json

## server builder image
build-server-image:
	cd hack/build/server && docker build --no-cache -t $(REGISTRY_URI)/basa-server-builder:$(SERVER_BUILD_VERSION) .

## ui builder image
build-ui-image:
	docker build -f hack/build/ui/Dockerfile -t $(REGISTRY_URI)/basa-ui-builder:$(UI_BUILD_VERSION) .

# release, requiring Docker 17.05 or higher on the daemon and client
build-backend-image:
	@echo "version: $(RELEASE_VERSION)"
	docker build --no-cache -t $(REGISTRY_URI)/basa-backend:$(RELEASE_VERSION) -f hack/build/backend/Dockerfile .

build-frontend-image:
	@echo "version: $(RELEASE_VERSION)"
	docker build --no-cache -t $(REGISTRY_URI)/basa-frontend:$(RELEASE_VERSION) -f hack/build/frontend/Dockerfile .

push-image:
	docker tag $(REGISTRY_URI)/basa-backend:$(RELEASE_VERSION) $(REGISTRY_URI)/basa-backend:latest
	docker push $(REGISTRY_URI)/basa-backend:$(RELEASE_VERSION)
	docker push $(REGISTRY_URI)/basa-backend:latest
	docker tag $(REGISTRY_URI)/basa-frontend:$(RELEASE_VERSION) $(REGISTRY_URI)/basa-frontend:latest
	docker push $(REGISTRY_URI)/basa-frontend:$(RELEASE_VERSION)
	docker push $(REGISTRY_URI)/basa-frontend:latest

release: build-backend-image build-frontend-image push-image