
FROM ubuntu:latest

ENV PROMETHEUS_VERSION="2.50.1" 
ENV PROMETHEUS_HOME="/opt/prometheus"

RUN apt-get update && \
    apt-get install -y wget curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 ${PROMETHEUS_HOME}

RUN useradd -rs /bin/false prometheus && \
    chown -R prometheus:prometheus ${PROMETHEUS_HOME}


EXPOSE 9090

USER prometheus


WORKDIR ${PROMETHEUS_HOME}
ENTRYPOINT ["./prometheus"]
CMD ["--config.file=prometheus.yml", "--storage.tsdb.path=./data"]