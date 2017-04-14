#!/usr/bin/env bash
echo "********** RESETTING ALL **********"

echo "********** Stopping Services **********"

docker-compose down

echo "********** Removing MySql Data **********"

sudo rm -rf mysql/.data

echo "********** Development Repos **********"




echo "********** Starting Services **********"

# docker network create airflow_net
docker-compose up -d --build
sleep 10

# echo "********** Upgrading Database Scheme **********"
# docker-compose exec product_service  python manage.py db upgrade

echo "********** Creating Admin User  **********"
docker-compose exec worker python scripts/reset_create_admin.py


echo "********** Reset Completed  **********"

echo "********** Tailing Logs  *************"
docker-compose logs -f
