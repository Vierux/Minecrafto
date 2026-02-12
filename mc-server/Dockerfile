# Cambiamos a la versión estable de Debian para evitar el error 100 de Sid
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid

WORKDIR /usr/src/serverfiles

# Instalamos dependencias (incluyendo curl y jq que faltaban)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    jq \
    openjdk-21-jre-headless \
    tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/src/start.sh
RUN chmod +x /usr/src/start.sh

# Aseguramos que el directorio de trabajo exista
RUN mkdir -p /usr/src/serverfiles

CMD ["/bin/bash", "/usr/src/start.sh"]