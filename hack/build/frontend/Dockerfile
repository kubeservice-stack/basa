# requiring Docker 17.05 or higher on the daemon and client
# see https://docs.docker.com/develop/develop-images/multistage-build/
# BUILD COMMAND :
# docker --build-arg RELEASE_VERSION=v1.0.0 -t infra/basa:v1.0.0 .

# build ui
FROM dongjiang1989/basa-ui-builder:v1.0.2 as frontend

COPY src/frontend /workspace

RUN cd /workspace && \
    npm run build:aot

# build server
FROM openresty/openresty:1.15.8.3-2-centos

COPY --from=frontend /workspace/dist/ /usr/local/openresty/nginx/html/

ENV DOMAIN=https://s3.kubeservice.cn/

RUN sed -i "s#src=\"runtime#src=\"${DOMAIN}runtime#g" /usr/local/openresty/nginx/html/index.html
RUN sed -i "s#src=\"polyfills#src=\"${DOMAIN}polyfills#g" /usr/local/openresty/nginx/html/index.html
RUN sed -i "s#src=\"scripts#src=\"${DOMAIN}scripts#g" /usr/local/openresty/nginx/html/index.html
RUN sed -i "s#src=\"vendor#src=\"${DOMAIN}vendor#g" /usr/local/openresty/nginx/html/index.html
RUN sed -i "s#src=\"main#src=\"${DOMAIN}main#g" /usr/local/openresty/nginx/html/index.html

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    sed -i '/index  index.html index.htm;/a\        try_files $uri $uri/ /index.html;' /etc/nginx/conf.d/default.conf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
