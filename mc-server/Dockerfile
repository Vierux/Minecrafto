FROM eclipse-temurin:21-jre-alpine

ENV TZ=Europe/Madrid

RUN apk add --no-cache bash curl jq wget tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

WORKDIR /usr/src/serverfiles

COPY start.sh /usr/src/start.sh
RUN chmod +x /usr/src/start.sh

CMD ["/bin/bash", "/usr/src/start.sh"]