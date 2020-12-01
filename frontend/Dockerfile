FROM node:14.13.1

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ENV HOST 0.0.0.0

WORKDIR /app

RUN apt-get update -y && \
    apt-get upgrade -y && \
    yarn install

ADD . /app

RUN yarn run build
EXPOSE 3000

CMD ["yarn", "run", "start"]
