FROM registry.cn-hangzhou.aliyuncs.com/zbsg/node-alpine:6.10.0

COPY / /opt/rancher-deploy

RUN npm install unirest -g

ENV PATH=/opt/rancher-deploy:$PATH

RUN ln -s /opt/rancher-deploy/run /usr/bin/deploy && \
  which deploy && \
  which build && \
  which destroy

ENTRYPOINT []
CMD []