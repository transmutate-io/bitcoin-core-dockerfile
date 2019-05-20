FROM debian:9.9-slim

ENV VERSION 0.18.0

ENV PATH /opt/bitcoin-${VERSION}/bin:$PATH

RUN useradd -r bitcoin && \
    apt-get update -y && \
    apt-get install -y curl gnupg gosu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import && \
    curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc && \
    curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz && \
    gpg --verify SHA256SUMS.asc && \
    grep " bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c - && \
    tar -xzf *.tar.gz -C /opt && \
    rm *.tar.gz *.asc

COPY entrypoint.sh /

ENV DATA "/data"
RUN mkdir -p "${DATA}" /home/bitcoin && \
    chmod 700 "${DATA}" /home/bitcoin && \
    chown -R bitcoin "${DATA}" /home/bitcoin && \
    chmod 555 /entrypoint.sh

VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]