# Symfony 7.4 + Docker (nginx + php-fpm + Postgres) — Make-файл
COMPOSE := docker compose
PHP     := $(COMPOSE) exec php

.PHONY: help up down restart ps logs logs-nginx logs-php build sh sql console cache-clear migrate-install migrate-diff make-migration db-create composer-install

help: ## Показать список команд
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Поднять все контейнеры (nginx: http://localhost:8080)
	$(COMPOSE) up -d --build

down: ## Остановить и удалить контейнеры
	$(COMPOSE) down

restart: ## Перезапустить контейнеры
	$(COMPOSE) restart

ps: ## Статус контейнеров
	$(COMPOSE) ps

logs: ## Логи всех сервисов
	$(COMPOSE) logs -f --tail=100

logs-nginx: ## Логи nginx
	$(COMPOSE) logs -f nginx

logs-php: ## Логи php-fpm
	$(COMPOSE) logs -f php

build: ## Пересобрать образы
	$(COMPOSE) build --no-cache

sh: ## Shell в контейнере php
	$(PHP) sh

sql: ## Подключиться к Postgres через psql
	$(COMPOSE) exec database psql -U app -d app

console: ## Symfony console (make console ARGS="debug:router")
	$(PHP) bin/console $(ARGS)

cache-clear: ## Очистить кэш
	$(PHP) bin/console cache:clear

db-create: ## Создать базу данных
	$(PHP) bin/console doctrine:database:create --if-not-exists

migrate-install: ## Выполнить миграции
	$(PHP) bin/console doctrine:migrations:migrate --no-interaction

migrate-diff: ## Сгенерировать diff миграций по сущностям
	$(PHP) bin/console doctrine:migrations:diff

make-migration: ## Создать пустую миграцию (make make-migration NAME="AddUserTable")
	$(PHP) bin/console doctrine:migrations:generate --name=$(NAME)

composer-install: ## composer install внутри контейнера
	$(PHP) composer install
