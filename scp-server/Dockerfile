FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid

RUN apt-get update && \
    apt-get install -y openssh-server tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd

COPY start.sh /usr/src/start.sh
RUN chmod +x /usr/src/start.sh

CMD ["/bin/bash", "/usr/src/start.sh"]