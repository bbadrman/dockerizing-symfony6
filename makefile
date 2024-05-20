THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: build up stop destroy restart ps logs logs-web logs-db web db install symfony-me symfony-mc symfony-mm symfony-dmm symfony-dfl kill-all stop-all
build:
	docker-compose up -d --force-recreate --build
up:
	docker-compose up -d
stop:
	docker-compose stop
destroy:
	docker-compose down -v
restart:
	docker-compose restart
ps:
	docker-compose ps
logs:
	docker-compose logs --tail=100 -f
logs-web:
	docker-compose logs --tail=100 -f web
logs-db:
	docker-compose logs --tail=100 -f db
web:
	docker-compose exec web bash
db:
	docker-compose exec db bash
install:
	docker-compose exec web composer require
symfony-me:
	docker-compose exec web php bin/console make:entity
symfony-mc:
	docker-compose exec web php bin/console make:controller
symfony-mm:
	docker-compose exec web php bin/console make:migration
symfony-dmm:
	docker-compose exec web php bin/console doctrine:migrations:migrate
symfony-dfl:
	docker-compose exec web php bin/console doctrine:fixtures:load
c-c:
	docker-compose exec web php bin/console cache:clear
kill:
	docker-compose kill
kill-all:
	@docker kill $$(docker ps -q)
stop-all:
	@CONTAINERS=$$(docker ps -q); \
	if [ -n "$$CONTAINERS" ]; then \
		docker stop $$CONTAINERS; \
	else \
		echo "No running containers to stop."; \
	fi
stup:
	@make stop-all
	@make up
klup:
	@make kill-all
	@make up