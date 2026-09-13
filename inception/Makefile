NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	sudo mkdir -p /home/omaezzem/data/mariadb
	sudo mkdir -p /home/omaezzem/data/wordpress
	$(COMPOSE) up --build -d

clean:
	$(COMPOSE) stop

fclean: clean
	$(COMPOSE) rm -f

down: fclean
	$(COMPOSE) down --rmi local -v

re: down all

.PHONY: all clean fclean down re