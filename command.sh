sudo  docker compose run --rm -p8005:8005 bl_app bash -c "cd bl_cms && php artisan serve --host=0.0.0.0 --port=8005"
