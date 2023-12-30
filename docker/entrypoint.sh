#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
    else
        echo "env file exist"
fi

# Sprawdzenie, czy migracje zostały już wykonane
if [ ! -f "migrations_executed.flag" ]; then
    php artisan key:generate && echo "Key generated successfully!" || echo "Key generation failed!"
    php artisan cache:clear && echo "Cache cleared successfully!" || echo "Cache clearance failed!"
    php artisan config:clear && echo "Config cleared successfully!" || echo "Config clearance failed!"
    php artisan route:clear && echo "Route cache cleared successfully!" || echo "Route cache clearance failed!"
    php artisan migrate && echo "Migrations executed successfully!" || echo "Migration failed!"

    # Utworzenie pliku flagi po wykonaniu migracji
    touch migrations_executed.flag
else
    echo "Migrations already executed."
fi

php artisan serve --port=$PORT --host=0.0.0.0 --env=.env && echo "Server started" || echo "Server failed!"

exec docker-php-entrypoint "$@"
