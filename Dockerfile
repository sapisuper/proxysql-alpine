FROM alpine:3.7 as builder

MAINTAINER Satria Dwi Putra <satria11t2@gmail.com>

WORKDIR /tmp
RUN apk add -t build-depends build-base automake bzip2 patch git cmake openssl-dev libc6-compat libexecinfo-dev && \
    git clone https://github.com/sysown/proxysql.git && \
    cd proxysql && \
    git checkout v1.4.12 && \
    make clean && \
    make build_deps && \ 
    NOJEMALLOC=1 make 

FROM alpine:3.7
MAINTAINER Satria Dwi Putra <satria11t2@gmail.com>
RUN apk add --no-cache -t runtime-depends libgcc libstdc++ libcrypto1.0 libssl1.0

COPY --from=builder /tmp/proxysql/src/proxysql /usr/bin/proxysql
COPY proxysql.cnf /proxysql/proxysql.cnf
RUN mkdir /var/lib/proxysql
ENTRYPOINT ["proxysql", "-f", "-c", "/proxysql/proxysql.cnf"]
