FROM ubuntu:18.04
COPY . /app

RUN apt-get update && apt-get install -y nasm build-essential

WORKDIR /app

CMD bash