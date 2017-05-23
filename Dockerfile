FROM registry.cn-hangzhou.aliyuncs.com/zbsg/node-alpine:6.10.0

COPY . /opt/rancher-deploy

RUN npm install unirest

ENV PATH=/opt/rancher-deploy:$PATH

RUN cd /opt/rancher-deploy && ls

RUN ln -s /opt/rancher-deploy/deploy /usr/bin/deploy && \
  which deploy

ENTRYPOINT []
CMD []