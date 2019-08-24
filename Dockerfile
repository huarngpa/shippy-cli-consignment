###########
# BUILDER #
###########

FROM golang:alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache git

RUN mkdir /app
WORKDIR /app

ENV GO111MODULE=on

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-cli-consignment


#########
# FINAL #
#########

FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app

COPY --from=builder /app/shippy-cli-consignment .
COPY consignment.json /app/consignment.json

CMD ["./shippy-cli-consignment"]
