from debian:buster

# Install prerequisite Debian packages.
RUN apt-get update && \
    apt-get install -y \
        doxygen \
        git \
        golang \
        protobuf-compiler

# Install prerequisite golang packages.
RUN go get github.com/client9/gospell && \
    go get github.com/golang/protobuf/proto && \
    go get gopkg.in/russross/blackfriday.v2

# Download the Istio tools.
ADD https://github.com/istio/tools/archive/master.tar.gz /tmp/istio-tools.tar.gz

# Build and install the Istio protoc document generator.
RUN tar -C /tmp/ -xzf /tmp/istio-tools.tar.gz && \
    mkdir -p /root/go/src/istio.io/tools/pkg/ && \
    cp -r /tmp/tools-master/pkg/protocgen /root/go/src/istio.io/tools/pkg && \
    cd /tmp/tools-master/protoc-gen-docs && \
    go build && \
    cp protoc-gen-docs /usr/local/bin/
