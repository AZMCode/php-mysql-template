#!/usr/bin/env bash
printf "$(< ./04-server-auth.sql.template)" "$(< ./server_password)" > ./sql/04-server-auth.sql