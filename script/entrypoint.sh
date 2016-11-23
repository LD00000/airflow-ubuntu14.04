#!/usr/bin/env bash

exec airflow initdb

exec airflow webserver -p 8080 
exec airflow scheduler  
