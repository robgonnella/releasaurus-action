FROM rgonnella/releasaurus:v0.2.3

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
