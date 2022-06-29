FROM python:3.8-alpine

RUN addgroup webssh && \
  adduser -Ss /bin/false -g webssh webssh

WORKDIR /code

COPY --chown=webssh:webssh requirements.txt .

RUN \
  apk add --no-cache tini libc-dev libffi-dev gcc && \
  pip install -r requirements.txt --no-cache-dir && \
  apk del gcc libc-dev libffi-dev
  
COPY --chown=webssh:webssh . /code

EXPOSE 8888/tcp
USER webssh
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["python", "run.py", "--fbidhttp=false", "--maxconn=500"]
