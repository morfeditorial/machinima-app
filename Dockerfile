FROM php:8.4-cli

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
        supervisor \
        git \
        unzip \
        libpq-dev \
        curl \
        libssl-dev \
    && docker-php-ext-install \
        pdo_pgsql \
        opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Copy application code
COPY . .

# Create Symfony var directories
RUN mkdir -p /app/var/cache /app/var/log /app/var/sessions \
    && chmod -R 777 /app/var

# Warm up Symfony cache
RUN php bin/console cache:warmup --no-interaction || true

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
