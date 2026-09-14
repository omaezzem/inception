# Developer Documentation

This document explains how a developer can set up, build, and manage the Inception project.

## 1. Setting up the environment from scratch

### Prerequisites

- A Linux machine or VM
- [Docker](https://docs.docker.com/engine/install/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- `make` installed
- `git` to clone the repository

### Clone the project

```bash
git clone <repository_url> inception
cd inception
```

### Configuration files

- **`.env`** (project root): non-sensitive configuration read by Docker Compose — domain name, database name, WordPress site title/usernames, etc. Copy the example file if one is provided and fill in your own values:
  ```bash
  cp .env.example .env
  ```

 Each file must contain only the password/value, nothing else. These files are referenced as Docker secrets in `docker-compose.yml` and must **never** be committed to Git.

### Local domain

Add your omaezzem's domain to `/etc/hosts` so it resolves locally:

```
127.0.0.1   omaezzem.42.fr
```

## 2. Building and launching with the Makefile / Docker Compose

The `Makefile` at the project root wraps Docker Compose commands:

```bash
make          # build images and start all containers (detached)
make down     # stop and remove containers
make clean    # remove containers and built images
make fclean   # fclean + remove volumes (all persisted data is lost)
make re       # fclean, then build and start again
```

Under the hood, `make` runs:

```bash
docker compose -f ./srcs/docker-compose.yml up --build -d
```

Project layout (typical):

```
├── DEV_DOC.md
├── Makefile
├── README.md
├── srcs
│   ├── docker-compose.yml
│   └── requirements
│       ├── mariadb
│       │   ├── conf
│       │   │   └── mariadb.conf
│       │   ├── Dockerfile
│       │   └── tools
│       │       └── mrdb.sh
│       ├── nginx
│       │   ├── conf
│       │   │   └── nginx.conf
│       │   └── Dockerfile
│       └── wordpress
│           ├── Dockerfile
│           └── tools
│               └── wp.sh
└── USER_DOC.md

```

## 3. Managing containers and volumes

Useful Docker commands while developing:

```bash
# Containers
docker ps                          # list running containers
docker ps -a                       # list all containers, including stopped
docker logs -f <container_name>    # follow a container's logs
docker exec -it <container_name> sh   # open a shell inside a container
docker compose -f srcs/docker-compose.yml restart <service>  # restart one service

# Images
docker images                      # list built images
docker compose -f srcs/docker-compose.yml build --no-cache   # rebuild without cache

# Volumes
docker volume ls                   # list volumes
docker volume inspect <volume_name>   # see where a volume lives and how it's used

# Networks
docker network ls                  # list networks
docker network inspect <network_name> # see which containers are attached
```

If you change a `Dockerfile` or a service's config, rebuild that service:

```bash
docker compose -f srcs/docker-compose.yml up --build -d <service>
```

## 4. Where project data is stored and how it persists

Data persistence relies on two **named Docker volumes**, declared in `docker-compose.yml` and bound to fixed paths on the host:

- **WordPress volume** — stores WordPress files (uploads, plugins, themes, core files), typically mounted at `/var/www/html` inside the WordPress/NGINX containers.
- **MariaDB volume** — stores the database files, typically mounted at `/var/lib/mysql` inside the MariaDB container.

On the host, these volumes are usually bound to a fixed location such as `/home/omaezzem/data/wordpress` and `/home/omaezzem/data/mariadb` (check the `volumes:` section in `docker-compose.yml` for the exact paths).

Because these are named volumes (not ephemeral container storage), data survives:
- `make down` / `docker compose down` — containers are removed but volumes stay.
- `make re` without `fclean` — rebuilding images doesn't wipe volumes.

Data is only lost when the volumes themselves are removed, i.e.:

```bash
make fclean
# or manually:
docker compose -f srcs/docker-compose.yml down -v
```

To inspect volume content directly on the host:

```bash
docker volume inspect <volume_name>   # shows the "Mountpoint" path
sudo ls <mountpoint_path>
```