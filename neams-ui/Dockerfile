FROM node:16.13.1-alpine

ARG WORKDIR
ARG CONTAINER_PORT

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0

# ENV check（このRUN命令は確認のためなので無くても良い）
RUN echo ${HOME} && echo ${CONTAINER_PORT}

WORKDIR ${HOME}

EXPOSE ${CONTAINER_PORT}
