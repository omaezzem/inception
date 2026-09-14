*This project has been created as part of the 42 curriculum by omaezzem.*
 
# Inception
 
## Description
 
Inception is a 42 system administration project. The goal is to learn Docker by building a small infrastructure from scratch, using custom Docker images (no ready-made images from Docker Hub) orchestrated with Docker Compose.
 
The setup runs three containers, each with its own Dockerfile:
 
- **NGINX** – entry point, serves the site over TLS.
- **WordPress** + php-fpm – the website.
- **MariaDB** – the database.
## Instructions
 
**Requirements:** Docker, Docker Compose, `make`.
 
1. Add your domain to `/etc/hosts`:
```
   127.0.0.1   omaezzem.42.fr
```
2. Fill in your `.env` file`.
3. Build and start everything:
```bash
   make
```
4. Visit `https://omaezzem.42.fr`
Other commands:
```bash
make down     # stop containers
make clean    # remove containers and images
make fclean   # also remove volumes
make re       # fclean + rebuild
```
 
## Project Description — Docker Choices
 
**VM vs Docker:** A VM virtualizes a whole machine (own OS, heavy, slow to start). Docker only isolates processes and shares the host kernel, so it's lighter and faster. That's why each service here runs in its own container instead of its own VM.
 
**Secrets vs Environment Variables:** Env variables are fine for non-sensitive config (domain name, DB name, usernames) but are visible in `docker inspect`. Passwords are stored as Docker secrets instead, mounted as files and not exposed that way.
 
**Docker Network vs Host Network:** With host network, containers share the host's network directly (no isolation). Here, a dedicated Docker network is used so WordPress and MariaDB are only reachable from other containers, not from outside. Only NGINX exposes a port.
 
**Docker Volumes vs Bind Mounts:** Bind mounts link a container path directly to a host path, managed by hand. Docker volumes are managed by Docker itself, more portable, and are used here to persist WordPress files and the MariaDB database.
 
## Resources
 
- [Docker docs](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
- [NGINX docs](https://nginx.org/en/docs/)
- [WordPress developer docs](https://developer.wordpress.org/)
- [MariaDB docs](https://mariadb.com/kb/en/documentation/)
**AI usage:** explain general Docker concepts (secrets, volumes vs bind mounts) and deep concepts of docker also the explanation of the commands flags that there is no good explanation in the man page .
