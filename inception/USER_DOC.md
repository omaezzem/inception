# User Documentation

This document explains how to use and manage the Inception stack as an end user or administrator.

## 1. What services are provided

The stack is made of three containers working together:

- **NGINX** – the entry point. It's the only service reachable from outside, and it serves the site over HTTPS (TLS).
- **WordPress** (with php-fpm) – the website itself (blog/CMS).
- **MariaDB** – the database that stores WordPress's content (posts, users, settings).

NGINX talks to WordPress, and WordPress talks to MariaDB. Only NGINX exposes a port to the outside.

## 2. Starting and stopping the project

From the project root:

```bash
make          # build and start all services
make down     # stop and remove the containers
make re       # rebuild everything from scratch
```

After `make`, wait a few seconds for the containers to finish starting before opening the site.

## 3. Accessing the website and admin panel

- **Website:** `https://omaezzem.42.fr`
- **Admin panel:** `https://omaezzem.42.fr/wp-admin`

Your browser may show a security warning because the TLS certificate is self-signed — this is expected for a local project, just accept/continue.

Log in to the admin panel with the WordPress admin username and password (see below for where to find them).

## 4. Finding and managing credentials

Credentials are never hard-coded in the code — they're kept in two places:

- **`.env` file** (project root): non-sensitive settings such as the domain name, database name, and usernames.

To find a specific credential, open the matching file in `secrets/` (e.g. `wp_admin_password.txt` for the WordPress admin password).

To change a password:
1. Edit the corresponding .env.
2. Restart the stack: `make down` then `make`.

## 5. Checking that services are running correctly

List running containers:

```bash
docker ps
```

You should see three containers (NGINX, WordPress, MariaDB) with a status of `Up`.

Check a specific container's logs if something looks wrong:

```bash
docker logs <container_name>
```

Quick health checks:
- Open `https://omaezzem.42.fr` — the WordPress homepage should load.
- Open `https://omaezzem.42.fr/wp-admin` — the omaezzem page should appear.
- If a page doesn't load, check the NGINX logs first, then WordPress, then MariaDB.

If a container keeps restarting or shows `Exited`, it usually means it crashed on startup — check its logs with the command above to see the error.