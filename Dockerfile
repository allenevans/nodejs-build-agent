FROM docker

MAINTAINER Allen Evans

ENV REPO=undefined TAG=undefined BUILD_ID=0

RUN apk --no-cache add openssh git nodejs=6.9.5-r0 && \
    rm -rf /var/cache/apk/* && \
    touch ./root/.bashrc && \
    echo eval \`ssh-agent -s\` >> /root/.bashrc && \
    echo ssh-add /ssh/id_rsa >> /root/.bashrc && \
    mkdir -p /__build__

COPY tools/* /usr/bin/

CMD build
