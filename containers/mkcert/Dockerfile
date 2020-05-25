FROM golang:1.14-alpine

ARG MKCERT_REV=master

RUN apk add --update --no-cache --virtual .build-deps \
        git

RUN git clone https://github.com/FiloSottile/mkcert \
    && cd mkcert \
    && git checkout $MKCERT_BRANCH \
	&& go build -ldflags "-X main.Version=$(git describe --tags)" -o /bin/mkcert \
    && rm -rf ../mkcert \
    && apk del .build-deps

WORKDIR /root/.local/share/mkcert