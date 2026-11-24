# Symfony 7.4 + Docker (nginx + php-fpm 8.6 + Postgres 16)

## Быстрый старт
```bash
make up            # собрать и поднять контейнеры
open http://localhost:8080
```

## Сервисы
| Сервис   | Образ                | Порт |
|----------|----------------------|------|
| nginx    | symfony-nginx        | 8080 |
| php-fpm  | symfony-php8-fpm     | 9000 (внутр.) |
| database | postgres:16-alpine   | 5432 |

## Команды Make
`make help` — полный список. Основные:
- `make sh` — shell в контейнере php
- `make console ARGS="debug:router"` — bin/console
- `make sql` — psql к базе
- `make db-create`, `make migrate-install`, `make migrate-diff` — Doctrine
- `make logs` / `logs-nginx` / `logs-php`

## Структура docker
- `docker/php/Dockerfile` — PHP 8.6-fpm-alpine, расширения intl/opcache/pdo_pgsql, Composer
- `docker/nginx/Dockerfile` + `default.conf` — nginx, fastcgi_pass php:9000
- `docker-compose.yml` — php + nginx + database (healthcheck, volume database_data)
