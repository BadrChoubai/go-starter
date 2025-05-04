FROM golang:1.24 AS builder

ARG OS="linux"
ARG ARCH="amd64"

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

ENV CGO_ENABLED=1 GOOS=${OS} GOARCH=${ARCH}

RUN go build -o main ./...

FROM debian:latest AS final

WORKDIR /root/

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main .

RUN chmod +x main

# Command to run the executable
CMD ["./main", "docker"]
