root@bootcamp-exercise-jason:~/exercise# vi ./entrypoint.sh 

#!/bin/bash
set -e
# This entrypoint is used to play nicely with docker-compose which relies
# heavily on environment variables itself for configuration,
# we'd have to define multiple environment variables and that makes no sense
# so this little entrypoint does all this for us.
export DJANGO_CACHE_URL=redis://redis:6379/0

# the official postgres image uses 'postgres' as default user if not set
# explictly.
if [ -z "$POSTGRES_ENV_POSTGRES_USER" ]; then
    export POSTGRES_ENV_POSTGRES_USER=postgres
fi

export DATABASE_URL=postgres://$POSTGRES_ENV_POSTGRES_USER:$POSTGRES_ENV_POSTGRES_PASSWORD@dbcontainer:5432/bootcamp

export CELERY_BROKER_URL=$DJANGO_CACHE_URL

python manage.py runserver 0.0.0.0:8000

exec "$@"
