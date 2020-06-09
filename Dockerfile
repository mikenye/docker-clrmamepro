FROM jlesage/baseimage-gui:ubuntu-18.04

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        file \
        p7zip-full \
        p7zip-rar \
        unzip \
        wine64 \
        zip \
        && \
    # Find latest clrmamepro
    CMP_LATEST_BINARY=$( \
        curl https://mamedev.emulab.it/clrmamepro/ | \
        sed -n 's/.*href="\([^"]*\).*/\1/p' | \
        grep -i binaries | \
        grep -i cmp | \
        grep -i _64.zip | \
        sort -r | \
        head -1 \
        ) && \
    # Document version
    echo $(basename --suffix=.zip $CMP_LATEST_BINARY | cut -d "_" -f 1) >> /VERSIONS && \
    # Install clrmamepro
    mkdir -p /opt/clrmamepro && \
    curl -o /tmp/cmp.zip "https://mamedev.emulab.it/clrmamepro/$CMP_LATEST_BINARY" && \
    unzip /tmp/cmp.zip -d /opt/clrmamepro/ && \
    # Allow window decorations
    sed -i '/<decor>no<\/decor>/d' /etc/xdg/openbox/rc.xml && \
    # Clean up
    apt-get remove -y \
        ca-certificates \
        curl \
        file \
        && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY startapp.sh /startapp.sh
COPY etc/ /etc/
COPY run_native_applications.reg /run_native_applications.reg

ENV APP_NAME="Clrmamepro"
