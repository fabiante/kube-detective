FROM golang:1.24 AS builder

WORKDIR /go/src/ghcr.io/fabiante/kube-detective
ADD . .
RUN --mount=type=cache,target=/go/pkg/mod \
	  --mount=type=cache,target=/root/.cache/go-build \
		make

FROM alpine:3.22
LABEL source_repository="https://github.com/fabiante/kube-detective"
RUN apk add --no-cache \
        ca-certificates \
        wget
COPY --from=builder /go/src/ghcr.io/fabiante/kube-detective/bin/linux/amd64/kube-detective /kube-detective
ENTRYPOINT ["/kube-detective"]
