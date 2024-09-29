FROM nginx:alpine AS nginx-builder

ENV NCHAN_VERSION=1.3.7

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
  apk add --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev && \
  curl -L --output nchan.tar.gz "https://github.com/slact/nchan/archive/v${NCHAN_VERSION}.tar.gz"

RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
  mkdir -p /usr/src && \
  tar -zxC /usr/src -f nginx.tar.gz && \
  tar -xzvf "nchan.tar.gz" && \
  NCHANDIR="$(pwd)/nchan-${NCHAN_VERSION}" && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  ./configure --with-compat $CONFARGS --add-dynamic-module=$NCHANDIR && \
  make && make install

FROM nginx:alpine

COPY --from=nginx-builder /usr/local/nginx/modules/ngx_nchan_module.so /usr/local/nginx/modules/ngx_nchan_module.so

# add nchan module to nginx config
RUN echo "load_module /usr/local/nginx/modules/ngx_nchan_module.so;" > /tmp/nchan_module_load.txt && \
  cat /tmp/nchan_module_load.txt /etc/nginx/nginx.conf > /tmp/new_nginx.conf && \
  mv /tmp/new_nginx.conf /etc/nginx/nginx.conf && \
  rm /tmp/nchan_module_load.txt

# Copy a custom nginx configuration if needed
COPY nginx.conf /etc/nginx/conf.d/default.conf

