# Build stage
FROM golang:1.21-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.darwin-arm64.tar.gz | tar xvz

# Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env . 
COPY start.sh .
COPY wait-for.sh .
RUN chmod +x start.sh .
RUN chmod +x wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD ["./main"]
ENTRYPOINT ["./wait-for.sh", "db-host:5432", "--", "./start.sh"]