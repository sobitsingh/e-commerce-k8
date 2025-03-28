FROM golang:1.24.1-alpine3.21 as builder

WORKDIR /usr/src/app

COPY . .

RUN go mod download

RUN go build -o /product-checkout .

FROM alpine as release

COPY --from=builder /product-checkout /product-checkout

ENV CHECKOUT_PORT=8092

ENTRYPOINT [ "./product-checkout" ]