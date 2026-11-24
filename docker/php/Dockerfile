# Symfony 7.4 + PHP 8.6 (fpm) + Postgres-клиент
FROM php:8.6-fpm-alpine

# Системные зависимости + PHP-расширения (intl, opcache, pdo_pgsql)
RUN apk add --no-cache git unzip icu-dev oniguruma-dev postgresql-client \
    && docker-php-ext-install -j"$(nproc)" intl opcache pdo pdo_pgsql

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

# Кэшируем зависимости
COPY composer.json composer.lock symfony.lock ./
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --prefer-dist --no-scripts --no-progress

# Код приложения
COPY . .

RUN mkdir -p var && chmod -R 777 var

ENV APP_ENV=prod \
    APP_DEBUG=0

EXPOSE 9000

CMD ["php-fpm", "-F"]
