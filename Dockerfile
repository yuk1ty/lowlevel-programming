FROM ubuntu:18.04
COPY . /app

RUN apt-get update && apt-get install -y nasm build-essential gdb

WORKDIR /app
RUN chmod +x gdb_setup.sh && ./gdb_setup.sh

CMD bash