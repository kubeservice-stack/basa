FROM node:16.13

WORKDIR /workspace

COPY src/frontend/package.json  /workspace

COPY src/frontend/package-lock.json  /workspace

RUN npm install --legacy-peer-deps --registry=https://registry.npmmirror.com
