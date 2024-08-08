FROM golang:1.22.6-alpine AS alpine

RUN apk add --no-cache git ca-certificates make

WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN make build

FROM scratch
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=alpine /app/gcp-quota-exporter /app/
WORKDIR /app
EXPOSE 9592
ENTRYPOINT ["./gcp-quota-exporter"]
