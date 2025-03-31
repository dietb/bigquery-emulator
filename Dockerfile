FROM ghcr.io/dietb/go-zetasql:latest

ARG VERSION

WORKDIR /work

COPY . ./

RUN go mod edit -replace github.com/goccy/go-zetasql=../go-zetasql
RUN go mod download

RUN make emulator/build

FROM debian:bookworm AS emulator

COPY --from=0 /work/bigquery-emulator /bin/bigquery-emulator

WORKDIR /work

ENTRYPOINT ["/bin/bigquery-emulator"]
