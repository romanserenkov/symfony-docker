# Symfony 7.4 + Docker (nginx + php-fpm 8.6 + Postgres 16 + Redis + RabbitMQ + Kafka)

## Быстрый старт
```bash
make up            # собрать и поднять контейнеры
open http://localhost:8080
```

## Сервисы
| Сервис      | Образ                       | Порт          |
|-------------|-----------------------------|---------------|
| nginx       | symfony-nginx               | 8080          |
| php-fpm     | symfony-php8-fpm            | 9000 (внутр.) |
| messenger   | symfony-php8-fpm (consume)  | —             |
| database    | postgres:16-alpine          | 5432          |
| redis       | redis:7-alpine              | 6379          |
| rabbitmq    | rabbitmq:4-management       | 5672 / 15672 (UI) |
| broker      | apache/kafka:3.9 (KRaft)    | 19092 (host)  |

## Symfony Messenger
Транспорты настроены в `config/packages/messenger.yaml`:
- `async` — DSN из `MESSENGER_TRANSPORT_DSN` (по умолчанию doctrine/Postgres)
- `rabbit` — RabbitMQ (`RABBITMQ_DSN`)
- `redis`  — Redis streams (`REDIS_MESSENGER_DSN`)
- `kafka`  — Kafka (`KAFKA_DSN`, расширение rdkafka)
- `failed` — дохлые сообщения в Postgres

Пример отправки:
```php
$bus->dispatch(new RabbitMessage('hello')); // → RabbitMQ
$bus->dispatch(new KafkaMessage('orders', 'payload')); // → Kafka
```
Контейнер `messenger` автоматически запускает `messenger:consume async rabbit redis kafka`.

## Команды Make
`make help` — полный список. Основные:
- `make sh` — shell в контейнере php
- `make console ARGS="debug:router"` — bin/console
- `make sql` — psql к базе
- `make db-create`, `make migrate-install`, `make migrate-diff` — Doctrine
- `make logs` / `logs-nginx` / `logs-php` / `logs-rabbit` / `logs-redis` / `logs-kafka`
- `make consume TRANSPORTS="async rabbit"` — ручной consumer
- `make redis-cli`, `make kafka-topics`, `make rabbit-ui`, `make setup-brokers`

## Структура docker
- `docker/php/Dockerfile` — PHP 8.6-fpm-alpine, расширения intl/opcache/pdo_pgsql/amqp/redis/rdkafka, Composer
- `docker/nginx/Dockerfile` + `default.conf` — nginx, fastcgi_pass php:9000
- `docker-compose.yml` — php, messenger, nginx, database, redis, rabbitmq, kafka (healthchecks, volumes)
