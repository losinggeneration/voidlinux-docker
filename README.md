# Void Linux Busybox musl Docker image

## Background

This image is a minimal Void Linux Docker image with `busybox-huge` instead of
`base-minimal` like the official `voidlinux/voidlinux` image. It also uses musl
instead of glibc which causes the image to be a bit smaller as well. At the
time of this writing the musl image is ~13Mb, the glibc image is ~51Mb, & the
voidlinux/voidlinux image is ~123Mb. This image, while a bit more than twice as
large as the alpine images, does put this in a spot where it could be usable as
a base image instead of alpine.

## Building

The default build is for x86\_64-musl. This is controlled by:
```
ARCH       - defauls to x86_64 and should be a valid Void arch
MUSL       - defaults to musl set to an empty string to use glibc
XBPS_ARCH  - Override the default $ARCH-$MUSL
```

Default musl build:
```
docker build -t voidlinux .
```

Basic glibc build requires overriding XBPS\_ARCH & MUSL:
```
docker build -t voidlinux:glibc --build-arg XBPS_ARCH=x86_64 --build-arg MUSL="" .
```

## Running

This image, by default builds a purposefully trimmed down musl image without
some of the more standard base system. If you want to get to a more full
featured system run:
```docker run -it losinggeneration/voidlinux
xbps-install -S base-minimal
```

