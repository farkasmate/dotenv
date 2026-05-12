ARG CRYSTAL_VERSION=latest
FROM crystallang/crystal:${CRYSTAL_VERSION}-alpine AS build

WORKDIR /build/

RUN apk add --no-cache \
  gpgme-dev

ADD \
  shard.lock \
  shard.yml \
  .

ADD src/ src/

ADD .git/HEAD .git/HEAD
ADD .git/objects/ .git/objects/
ADD .git/refs/ .git/refs/

RUN --mount=type=cache,target=/build/lib/ \
  --mount=type=cache,target=/root/.cache/ \
  shards build

ENTRYPOINT ["/build/bin/dotenv"]
