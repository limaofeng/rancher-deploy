FROM node:6.9-alpine

COPY . /app

WORKDIR /app

RUN npm install unirest

RUN which deploy && \
    which build && \
    which destroy

ENTRYPOINT []
CMD []