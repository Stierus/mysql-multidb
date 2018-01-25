#!/usr/bin/env bash
set -e

versions=(5 5.5 5.6 5.7 8 8.0 latest)
template=Dockerfile.template

for version in "${versions[@]}"; do
	dir="$version"

	mkdir -p "$dir"

	sed 's/%%MYSQL_VERSION%%/'"$version"'/g' \
		"$template" > "$dir/Dockerfile"

	cp -a "docker-entrypoint-initdb.d" "$version/"
done
