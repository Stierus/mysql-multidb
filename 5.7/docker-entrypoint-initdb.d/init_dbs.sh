#!/usr/bin/env bash
set -e

: ${MYSQL_DATABASES:=""}
: ${MYSQL_USERS:="$MYSQL_DATABASES"}
: ${MYSQL_PASSWORDS:=""}
: ${MYSQL_EXTRA_DATABASES:=""}

MYSQL_DATABASES=(${MYSQL_DATABASES})
MYSQL_USERS=(${MYSQL_USERS})
MYSQL_PASSWORDS=(${MYSQL_PASSWORDS})
MYSQL_EXTRA_DATABASES=(${MYSQL_EXTRA_DATABASES})

for i in "${!MYSQL_DATABASES[@]}"; do
	database="${MYSQL_DATABASES[$i]}"
	user="${MYSQL_USERS[$i]}"
	password="${MYSQL_PASSWORDS[$i]}"
	if [ -z "${password}" ]; then
		set -x
		"${mysql[@]}" "CREATE USER '${user}'@'%' ;"
		set +x
	else
		set -x
		"${mysql[@]}" "CREATE USER '${user}'@'%' IDENTIFIED BY '${password}' ;"
		set +x
	fi
	set -x
    "${mysql[@]}" <<-EOSQL
        CREATE DATABASE \`${database}\` ;
        GRANT ALL ON \`${database}\`.* TO '${user}'@'%' ;
EOSQL
	set +x
	for extra_db in "${MYSQL_EXTRA_DATABASES[@]}"; do
		set -x
		"${mysql[@]}" "GRANT ALL ON \`${extra_db}${service}\`.* TO '${service}'@'%' ;"
		set +x
    done
done
