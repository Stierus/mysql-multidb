#!/usr/bin/env bash
set -e

echo "Setting up multiple users..."

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
	echo "Creating database ${database}..."
	if [ -z "${password}" ]; then
		set -x
		"${mysql[@]}" -e "CREATE USER '${user}'@'%' ;"
		set +x
	else
		set -x
		"${mysql[@]}" -e "CREATE USER '${user}'@'%' IDENTIFIED BY '${password}' ;"
		set +x
	fi
	set -x
    "${mysql[@]}" -e "CREATE DATABASE \`${database}\` ; GRANT ALL ON \`${database}\`.* TO '${user}'@'%' ;"
	set +x
	for extra_db in "${MYSQL_EXTRA_DATABASES[@]}"; do
		set -x
		"${mysql[@]}" -e "GRANT ALL ON \`${extra_db}${service}\`.* TO '${service}'@'%' ;"
		set +x
    done
done
