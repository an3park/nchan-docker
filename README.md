# NGINX with Nchan Module

This project provides a Docker image for [NGINX](https://nginx.org/) with the [Nchan module](https://nchan.io/) integrated. It's designed to be easily deployable and customizable for your specific needs.

## Features

- NGINX Alpine-based image
- Nchan module integrated
- Multi-architecture support (amd64, arm64/v8)
- Automated build and push to GitHub Container Registry (GHCR)

## Usage

Start a container with the latest image:

```sh
docker run -d -p 80:80 --name nginx-nchan ghcr.io/an3park/nchan-docker:latest
```

With custom configuration:

```sh
docker run -d -p 80:80 -v /path/to/nginx.conf:/etc/nginx/conf.d/default.conf --name nginx-nchan ghcr.io/an3park/nchan-docker:latest
```

Docker Compose:

```yaml
services:
  nginx-nchan:
    image: ghcr.io/an3park/nchan-docker:latest
    ports:
      - '80:80'
    volumes:
      - /path/to/nginx.conf:/etc/nginx/conf.d/default.conf
```
