FROM mono

RUN apt-get update && \
    apt-get install -y curl && \
    export DUPLICATI_DEB=$(curl https://updates.duplicati.com/beta/latest-installers.js 2>/dev/null \
      | grep '\.deb' \
      | grep 'url' \
      | head -n1 \
      | sed 's/.\+"url"\: "\([^"]\+\)".\+/\1/') && \
    curl -L -o /duplicati.deb "$DUPLICATI_DEB" && \
    dpkg -i /duplicati.deb || apt-get install -fy && \
    export TINI_VERSION=$(curl -s https://github.com/krallin/tini/releases/latest \
      | sed 's/.\+tag\/\(.\+\)".\+/\1/') && \
    curl -L -o /usr/sbin/tini \
      https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-$(dpkg --print-architecture) && \
    chmod 0755 /usr/sbin/tini && \
    rm -f /duplicati.deb && \
    rm -rf /var/lib/apt/lists

ENTRYPOINT ["/usr/sbin/tini", "--"]

ENV XDG_CONFIG_HOME=/data
VOLUME /data

EXPOSE 8200
CMD ["/usr/bin/duplicati-server", "--webservice-port=8200", "--webservice-interface=any"]
