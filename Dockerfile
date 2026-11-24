# Symfony 7.4 skeleton + PHP 8.6 (последняя стабильная)
FROM php:8.6-cli-alpine AS symfony_app

# Системные зависимости + Composer
RUN apk add --no-cache git unzip icu-dev oniguruma-dev \
    && docker-php-ext-install -j"$(nproc)" intl opcache \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

# Кэшируем зависимости
COPY composer.json composer.lock symfony.lock ./
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --prefer-dist --no-scripts --no-progress

# Код приложения
COPY . .

# Права на var/ и запуск post-install скриптов
RUN mkdir -p var \
    && chown -R www-data:www-data var \
    && COMPOSER_ALLOW_SUPERUSER=1 php bin/console about > /dev/null 2>&1 || true

ENV APP_ENV=prod \
    APP_DEBUG=0

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
