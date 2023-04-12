#!/bin/bash

odoo \
  --http-port=80 \
  --init=base \
  --database=$POSTGRES_DB \
  --db_host=$POSTGRES_HOST \
  --db_password=$POSTGRES_PASSWORD \
  --db_user=$POSTGRES_USER