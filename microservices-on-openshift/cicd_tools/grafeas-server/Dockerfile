FROM golang:1.10.3

RUN mkdir -p /go/src/github.com/grafeas/
RUN cd /go/src/github.com/grafeas/ && \
    git clone https://github.com/grafeas/grafeas.git

WORKDIR /go/src/github.com/grafeas/grafeas
#Check out this commit if v1apha1 api required, work from HEAD if v1beta1 (11/18 v v buggy) required
RUN git checkout 12017f5996bfd58ce362748150d49f4fa7d99ac8

WORKDIR /go/src/github.com/grafeas/grafeas/samples/server/go-server/api/server/main
RUN CGO_ENABLED=0 go build -o grafeas-server .

FROM scratch
WORKDIR /
COPY --from=0 /go/src/github.com/grafeas/grafeas/samples/server/go-server/api/server/main/grafeas-server /grafeas-server
EXPOSE 8080
CMD ["/grafeas-server"]