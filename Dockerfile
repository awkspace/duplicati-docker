FROM mono

RUN apt-get update && \
    apt-get install -y cron curl git sqlite3 && \
    export S6_REPO="github.com/just-containers/s6-overlay" && \
    export S6_VERSION=$(curl https://$S6_REPO/releases/latest \
        | sed 's/.\+tag\/\(.\+\)".\+/\1/') && \
    curl -L \
        /tmp/s6-overlay.tar.gz \
        https://$S6_REPO/releases/download/$S6_VERSION/s6-overlay-amd64.tar.gz \
        | tar xzf - -C / && \
    export DUP_INSTALLER_DOMAIN="https://updates.duplicati.com" && \
    export DUP_INSTALLER_PATH="beta/latest-installers.js" && \
    export DUP_INSTALLERS="$DUP_INSTALLER_DOMAIN/$DUP_INSTALLER_PATH" && \
    export DUP_DEB=$(curl $DUP_INSTALLERS 2>/dev/null \
        | grep '\.deb' \
        | grep 'url' \
        | head -n1 \
        | sed 's/.\+"url"\: "\([^"]\+\)".\+/\1/') && \
    curl -L -o /duplicati.deb "$DUP_DEB" && \
    dpkg -i /duplicati.deb || apt-get install -fy && \
    rm -f /duplicati.deb && \
    rm -rf /var/lib/apt/lists

COPY bin /bin
COPY etc /etc
RUN ln -s /bin/duplicati-db-backup /etc/cron.hourly/
ENTRYPOINT ["/init"]

ENV XDG_CONFIG_HOME=/data
ENV PORT=8200
VOLUME /data

EXPOSE 8200
