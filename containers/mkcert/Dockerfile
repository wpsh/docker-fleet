FROM golang:1.14-alpine

ARG MKCERT_BRANCH=master

# Install build dependencies.
RUN apk add --update --no-cache --virtual .build-deps \
    	git

WORKDIR /go/mkcert

# Build the binary.
RUN git clone https://github.com/FiloSottile/mkcert /go/mkcert \
    && git checkout "$MKCERT_BRANCH" \
	&& go build -ldflags "-X main.Version=$(git describe --tags)" -o /bin/mkcert \
    && rm -rf ../mkcert \
    && apk del .build-deps

VOLUME /root/.local/share/mkcert
