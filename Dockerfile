FROM ubuntu:bionic

LABEL maintainer "Bea Hughes <bea@mumble.org.uk>"

RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
        curl gnupg2 apt-transport-https ca-certificates libx11-xcb1 libasound2 libgtk-3-0 libgbm1 libdrm2 \
  && curl -s https://updates.signal.org/desktop/apt/keys.asc > signal-repo.key \
  && apt-key add signal-repo.key \
  && echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" > \
    /etc/apt/sources.list.d/signal-xenial.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y signal-desktop

RUN groupadd -r signal && useradd --no-log-init -m -g signal signal

RUN chown root:root /opt/Signal/chrome-sandbox && chmod 4755 /opt/Signal/chrome-sandbox

USER "signal"

WORKDIR "/home/signal"

ENTRYPOINT /opt/Signal/signal-desktop --quiet >/dev/null 2>&1
# ENTRYPOINT /opt/Signal/signal-desktop 
