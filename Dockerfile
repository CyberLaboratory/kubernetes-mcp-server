FROM golang:latest AS builder

WORKDIR /app

COPY ./ ./

ARG GIT_COMMIT_HASH=unknown
ARG GIT_VERSION=unknown
ARG BUILD_TIME=unknown

RUN CGO_ENABLED=0 go build \
    -ldflags "-s -w \
      -X 'github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=${GIT_COMMIT_HASH}' \
      -X 'github.com/containers/kubernetes-mcp-server/pkg/version.Version=${GIT_VERSION}' \
      -X 'github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=${BUILD_TIME}' \
      -X 'github.com/containers/kubernetes-mcp-server/pkg/version.BinaryName=kubernetes-mcp-server'" \
    -o kubernetes-mcp-server ./cmd/kubernetes-mcp-server

FROM ubuntu:20.04
LABEL io.modelcontextprotocol.server.name="io.github.containers/kubernetes-mcp-server"
RUN useradd -u 1000 -r -s /bin/false mcp
WORKDIR /app
COPY --from=builder /app/kubernetes-mcp-server /app/kubernetes-mcp-server
USER 1000:1000
ENTRYPOINT ["/app/kubernetes-mcp-server"]
CMD ["--port", "8080"]

EXPOSE 8080
