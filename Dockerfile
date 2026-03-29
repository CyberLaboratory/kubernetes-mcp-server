FROM ubuntu:20.04

ARG VERSION=0.0.59

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL \
       "https://github.com/containers/kubernetes-mcp-server/releases/download/v${VERSION}/kubernetes-mcp-server-linux-amd64" \
       -o /usr/local/bin/kubernetes-mcp-server \
    && chmod +x /usr/local/bin/kubernetes-mcp-server

RUN useradd -u 1000 -r -s /bin/false mcp

USER 1000:1000

EXPOSE 8080

ENTRYPOINT ["kubernetes-mcp-server"]
CMD ["--port", "8080"]
