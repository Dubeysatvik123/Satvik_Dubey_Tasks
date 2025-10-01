FROM ubuntu:22.04

ENV GRAFANA_VERSION="10.1.0"
ENV GRAFANA_HOME="/opt/grafana"

RUN apt-get update && \
    apt-get install -y wget tar gnupg2 adduser libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz && \
    tar -xzf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz && \
    mv grafana-${GRAFANA_VERSION} ${GRAFANA_HOME}

RUN useradd -rs /bin/false grafana && \
    chown -R grafana:grafana ${GRAFANA_HOME}


WORKDIR ${GRAFANA_HOME}


EXPOSE 3000

USER grafana


ENTRYPOINT ["./bin/grafana-server"]
CMD ["--homepath=/opt/grafana", "--config=/opt/grafana/conf/defaults.ini"]
