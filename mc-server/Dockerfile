FROM debian:sid

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid

WORKDIR /usr/src/serverfiles

RUN apt-get update && \
    apt-get install -y curl wget jq openjdk-21-jre-headless tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/src/start.sh
RUN chmod +x /usr/src/start.sh

CMD ["/bin/bash", "/usr/src/start.sh"]