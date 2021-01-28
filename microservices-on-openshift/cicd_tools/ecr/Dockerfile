FROM golang:1.10.3

RUN mkdir -p /go/src/github.com/grafeas/ && \
    cd /go/src/github.com/grafeas/ && \
    git clone https://github.com/grafeas/grafeas.git

WORKDIR /go/src/github.com/grafeas/grafeas/samples/server/go-server/api/server/main
RUN CGO_ENABLED=0 go build -o grafeas-server .

FROM scratch
WORKDIR /
COPY --from=0 /go/src/github.com/grafeas/grafeas/samples/server/go-server/api/server/main/grafeas-server /grafeas-server
EXPOSE 8080
CMD ["/grafeas-server"]