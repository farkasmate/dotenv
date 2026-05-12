ARG CRYSTAL_VERSION=latest
FROM crystallang/crystal:${CRYSTAL_VERSION}-alpine

WORKDIR /build/

RUN apk add --no-cache \
  gpgme-dev

ADD \
  shard.yml \
  shard.lock \
  .

ADD src/ src/

RUN --mount=type=cache,target=/build/lib/ \
  shards build

ENTRYPOINT ["/build/bin/dotenv"]
