FROM docker:27-dind

WORKDIR /work

COPY entrypoint.sh /entrypoint.sh
COPY engine /engine
COPY tools /tools
COPY ui /ui

RUN sed -i 's/\r$//' /entrypoint.sh $(find /engine /ui /tools -name '*.sh') && \
    chmod +x /entrypoint.sh $(find /engine /ui /tools -name '*.sh')

ENTRYPOINT ["/entrypoint.sh"]