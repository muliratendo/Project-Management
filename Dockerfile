FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpq-dev nodejs npm \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Install PHP and Node dependencies, build assets
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

EXPOSE 10000
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=10000