FROM alpine:3.6

RUN	addgroup -S spiped \
&&	adduser -S -G spiped spiped

RUN	apk add --no-cache libssl1.0

ENV SPIPED_VERSION 1.6.0
ENV SPIPED_DOWNLOAD_URL https://www.tarsnap.com/spiped/spiped-1.6.0.tgz
ENV SPIPED_DOWNLOAD_SHA256 e6f7f8f912172c3ad55638af8346ae7c4ecaa92aed6d3fb60f2bda4359cba1e4

ENV GOSU_VERSION 1.10
ENV GOSU_DOWNLOAD_URL https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64
ENV GOSU_DOWNLOAD_SHA256 5b3b03713a888cee84ecbf4582b21ac9fd46c3d935ff2d7ea25dd5055d302d3c

RUN	set -x \
&&	apk add --no-cache --virtual .build-deps \
		curl \
		gcc \
		make \
		musl-dev \
		openssl-dev \
		tar \
&&      apk add --update bash \
&&	curl -fsSL "$SPIPED_DOWNLOAD_URL" -o spiped.tar.gz \
&&	echo "$SPIPED_DOWNLOAD_SHA256 *spiped.tar.gz" |sha256sum -c - \
&&	mkdir -p /usr/local/src/spiped \
&&	tar xzf "spiped.tar.gz" -C /usr/local/src/spiped --strip-components=1 \
&&	rm "spiped.tar.gz" \
&&	CC=gcc make -C /usr/local/src/spiped \
&&	make -C /usr/local/src/spiped install \
&&	rm -rf /usr/local/src/spiped \
&&      curl -fsSL "$GOSU_DOWNLOAD_URL" -o gosu \
&&      echo "$GOSU_DOWNLOAD_SHA256 *gosu" | sha256sum -c - \
&&      chmod 755 gosu \
&&	apk del .build-deps

VOLUME /spiped
WORKDIR /spiped

ADD entrypoint.sh /entrypoint.sh

# COPY *.sh /usr/local/bin/
# RUN chmod 755 /usr/local/bin/*.sh
ENTRYPOINT ["/entrypoint.sh"]
