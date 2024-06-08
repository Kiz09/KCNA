# Build Container Image
FROM alpine as cmatrixbuilder

WORKDIR cmatrix

RUN apk update --no-cache && \
    apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
    git clone https://github.com/spurin/cmatrix.git . && \
    autoreconf -i && \
    mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts && \
    ./configure LDFLAGS="-static" && \
    make

# cmatrix Container Image
FROM alpine 

LABEL org.opencontainers.image.authors="Kiz" \
      org.opencontainers.image.description="KCNA course from Jame Spurin - Matrix project"

RUN apk update --no-cache && \ 
    apk add ncurses-terminfo-base && \ 
    adduser -g "Thomas Anderson" -s /usr/sbin/nologin -D -H thomas

COPY --from=cmatrixbuilder /cmatrix/cmatrix /cmatrix

USER thomas
ENTRYPOINT ["./cmatrix"]
CMD ["-b"]
