FROM alpine:3.19.0 AS base_image 
# A non-root user container image for Nginx VOD module 

FROM base_image AS build

ARG UID=1001
ARG GID=1001
RUN echo 'UID=' $UID

RUN set -x \
# create nginx user/group first, to be consistent throughout container runtime variants
    && addgroup -g $GID -S nginx \
    && adduser -S -D -H -u $UID -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apk add --no-cache curl build-base openssl openssl-dev zlib-dev linux-headers pcre-dev ffmpeg ffmpeg-dev
RUN mkdir nginx nginx-vod-module

ARG NGINX_VERSION=1.23.1
# kaltura nginx-vod-module Version 1.25 (Sep. 24, 2019)
#ARG VOD_MODULE_VERSION=399e1a0ecb5b0007df3a627fa8b03628fc922d5e
# kaltura nginx-vod-module Version 1.29 (Oct. 2, 2021)
#ARG VOD_MODULE_VERSION=1cb4a5c8dbc0773b688580df18820395b34b0e6b 
# kaltura nginx-vod-module Version 1.32 (Oct. 16, 2023)
ARG VOD_MODULE_VERSION=b4d57ef0123decd03a09a621ce829314199d1557

RUN curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -C /nginx --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-vod-module/archive/${VOD_MODULE_VERSION}.tar.gz | tar -C /nginx-vod-module --strip 1 -xz
WORKDIR /nginx
RUN ./configure --prefix=/var/cache/nginx \
	--add-module=../nginx-vod-module \
	--with-http_ssl_module \
	--with-file-aio \
	--with-threads \
	--with-cc-opt='-O3'

RUN make \
    && make install
RUN rm -rf /var/cache/nginx/html /var/cache/nginx/conf/*.default


FROM base_image
ARG UID=1001
ARG GID=1001

RUN set -x \
    && addgroup -g $GID -S nginx \
    && adduser -S -D -H -u $UID -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx 
    
USER root

RUN  apk add --no-cache ca-certificates openssl pcre zlib ffmpeg
COPY --from=build /var/cache/nginx /var/cache/nginx
RUN mkdir -p /opt/static/videos/
COPY examples/nginx.conf /var/cache/nginx/conf/

# implement changes required to run NGINX as an unprivileged user
RUN sed -i 's,listen       80;,listen       8080;,' /var/cache/nginx/conf/nginx.conf 
RUN chown -R $UID:0 /var/cache/nginx \
    && chmod -R g+w /var/cache/nginx \
    && chown -R $UID:0 /opt/static/videos \
    && chmod -R g+w /opt/static/videos

USER nginx

RUN whoami

EXPOSE 8080

ENTRYPOINT ["/var/cache/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]
