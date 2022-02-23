FROM ubuntu:20.04 as build

LABEL maintainer="SDF Ops Team <ops@stellar.org>"

RUN mkdir -p /app
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y gpg curl git make ca-certificates apt-transport-https && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key|gpg --dearmor >/etc/apt/trusted.gpg.d/nodesource.gpg && \
    echo "deb https://deb.nodesource.com/node_16.x focal main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |gpg --dearmor >/etc/apt/trusted.gpg.d/yarnpkg.gpg && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn && apt-get clean

RUN yarn install
RUN yarn build

ENV PORT=80 UPDATE_DATA=false
EXPOSE 80

RUN node_modules/typescript/bin/tsc

ENTRYPOINT ["/usr/bin/node"]
CMD ["./backend/app.js"]
