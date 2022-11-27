# requiring Docker 17.05 or higher on the daemon and client
# see https://docs.docker.com/develop/develop-images/multistage-build/
# BUILD COMMAND :
# docker --build-arg RELEASE_VERSION=v1.0.0 -t infra/basa:v1.0.0 .

# build server
FROM 360cloud/basa-server-builder:v1.0.2 as backend

COPY go.mod /go/src/github.com/kubeservice-stack/basa
COPY go.sum /go/src/github.com/kubeservice-stack/basa
COPY src/backend /go/src/github.com/kubeservice-stack/basa/src/backend

RUN export GO111MODULE=on && \
    export GOPROXY=https://goproxy.io && \
    cd /go/src/github.com/kubeservice-stack/basa/src/backend && \
    bee generate docs && \
    bee pack -o /_build

# build release image
FROM dongjiang1989/centos:7

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=backend /_build/backend.tar.gz /opt/basa/

WORKDIR /opt/basa/

RUN tar -xzvf backend.tar.gz

CMD ["./backend"]
