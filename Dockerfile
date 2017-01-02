FROM node:6.9-alpine

COPY . /app

WORKDIR /app

RUN npm install unirest

ENTRYPOINT []
CMD []