FROM golang:1.16 as builder

WORKDIR /app
RUN go get -d -v golang.org/x/net/html
COPY *.go *.mod *.sum /app/
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o wfs-ls .

FROM centurylink/ca-certs
# Just use ubuntu if it's necessary to debug using a shell.
#FROM ubuntu:20.04
WORKDIR /app
COPY --from=builder /app/wfs-ls /app/
COPY ./icons /app/icons

CMD ["./wfs-ls"]
STOPSIGNAL SIGINT