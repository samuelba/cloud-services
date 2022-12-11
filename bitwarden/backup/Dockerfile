FROM alpine:latest

ENV PYTHONUNBUFFERED=1

ARG GOOGLE_SERVICE_ACCOUNT_JSON="bitwarden.json"

RUN apk add --no-cache \
    bash \
    curl \
    openssl \
    sqlite \
    tzdata

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV BACKUP_CMD /app/backup.sh
ENV CRON_TIME "0 */2 * * *"
ENV TIMESTAMP false
ENV CRONFILE /etc/crontabs/root
ENV LOGFILE /app/log/backup.log

WORKDIR /app
RUN mkdir tmp
RUN mkdir log

COPY backup.sh ./
COPY ${GOOGLE_SERVICE_ACCOUNT_JSON} ./
COPY entrypoint.sh ./
COPY upload.py ./
COPY requirements.txt ./

RUN touch ${LOGFILE}

RUN pip3 install -r requirements.txt

ENTRYPOINT ["/app/entrypoint.sh"]
