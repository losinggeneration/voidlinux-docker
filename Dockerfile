FROM alpine as void-build

RUN apk add wget ca-certificates

ARG ARCH=x86_64
ARG MUSL=musl
ARG XBPS_ARCH=${ARCH}-${MUSL}
ARG REPO=https://alpha.de.repo.voidlinux.org

RUN wget -q -O- ${REPO}/static/xbps-static-latest.${ARCH}-musl.tar.xz | tar xfJ -
RUN mkdir -p void/var/db/xbps && cp -r /var/db/xbps/keys/ void/var/db/xbps/
RUN xbps-install -Sy -R ${REPO}/current/${MUSL} -r void base-files xbps busybox-huge

RUN for i in $(chroot void busybox | tail -n+$(expr 1 + $(chroot void busybox | grep -n "^Currently" | cut -d: -f1)) | sed "s/,//g" | xargs echo); do \
	ln -s /usr/bin/busybox void/usr/bin/$i; \
done

RUN mkdir void/etc/ssl/certs && chroot void update-ca-certificates --fresh
RUN chroot void xbps-reconfigure -a

RUN chroot void sh -c 'xbps-rindex -c /var/db/xbps/htt*'
RUN rm -fr void/var/cache/xbps void/usr/share/man/*

FROM scratch

ARG ARCH=x86_64
ARG MUSL=musl
ARG XBPS_ARCH=${ARCH}-${MUSL}
ENV XBPS_ARCH=$XBPS_ARCH

COPY --from=void-build /void /
CMD ["sh"]

# vi: ft=dockerfile
