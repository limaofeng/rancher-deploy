FROM registry.cn-hangzhou.aliyuncs.com/zbsg/node-alpine:6.10.0

COPY . /app

WORKDIR /app

RUN npm install unirest

ENTRYPOINT []
CMD []