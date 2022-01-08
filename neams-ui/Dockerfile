# alpineベースのnodeイメージには最初からyarnがインストールされている
FROM node:16.13.1-alpine

# ARGはdocker-composeの変数から取得する。
ARG WORKDIR
ARG CONTAINER_PORT

# C.UTF-8のCとは、コンピューター用のen_US（英語）を意味する
# ja_JP.UTF-8は、理由がない限り使わない方が良い
# WORKDIRは$API_WORK_DIRを参照している。
ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0

WORKDIR ${HOME}

EXPOSE ${CONTAINER_PORT}
