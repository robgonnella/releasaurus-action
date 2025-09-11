FROM rgonnella/releasaurus:v0.2.2

USER root

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
