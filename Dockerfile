# Note: this Dockerfile is used for running conformance tests

# ---
# Stage 1: Install certs and build conformance binary
# ---
FROM docker.io/golang:1.13.6-alpine3.11 AS builder
RUN apk --update add git make ca-certificates && \
    mkdir -p /go/src/github.com/opencontainers/distribution-spec
WORKDIR /go/src/github.com/opencontainers/distribution-spec
ADD . .
RUN make conformance-binary && mv output/conformance.test /conformance.test

# ---
# Stage 2: Final image with nothing but certs & binary
# ---
FROM scratch AS final
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /conformance.test /conformance.test
ENTRYPOINT ["/conformance.test"]
