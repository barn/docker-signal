FROM bitnami/minideb:latest

LABEL maintainer "Bea Hughes <bea@mumble.org.uk>"

RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
        curl gnupg2 apt-transport-https ca-certificates libx11-xcb1 libasound2 libgtk-3-0 \
  && curl -s https://updates.signal.org/desktop/apt/keys.asc > signal-repo.key \
  && apt-key add signal-repo.key \
  && echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" > \
    /etc/apt/sources.list.d/signal-xenial.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y signal-desktop

RUN groupadd -r signal && useradd --no-log-init -r -g signal signal

USER "signal"

WORKDIR "/home/signal"

ENTRYPOINT /usr/local/bin/signal-desktop --quiet >/dev/null

