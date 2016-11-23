#!/usr/bin/env bash

# airflow initdb

# airflow webserver -p 8080 
# airflow scheduler 

AIRFLOW_HOME="/airflow"
CMD="airflow" 

if [ "$1" = "webserver" ] || [ "$1" = "worker" ] || [ "$1" = "scheduler" ] ; then
  if [ "$1" = "webserver" ]; then
    echo "Initialize database..."
    $CMD initdb
  fi
  sleep 5
fi

# Run the `airflow` command.
echo "Executing: $CMD $@"
exec $CMD "$@"
