# MySQL Multi-DB

MySQL Docker image to create multiple users/databases using environment variables

GitHub: https://github.com/jamesmallen/mysql-multidb

# Why would I want this?

For production, it is often recommended to have separate database instances for every service. For testing and local development, though, it is often convenient to have a single database container shared by multiple services. It's possible to do this by creating scripts and using the official [mysql](https://hub.docker.com/_/mysql/) Docker image. This image makes it easier to set up a multi-database server for testing/development using only environment variables.

# How to use this image

## Quickstart

```console
$ docker run --name test-mysql -e MYSQL_DATABASES="foo bar" -d jamesmallen/mysql-multidb
```

... will create two databases, `foo` and `bar`, and two users, `foo` and `bar`, both of which have an empty password.

## Setting passwords

```console
$ docker run --name test-mysql -e MYSQL_DATABASES="foo mar" -e MYSQL_PASSWORDS="secretpassword1 secretpassword2" -d jamesmallen/mysql-multidb
```

... will create two databases, `foo` and `bar`, and two users, `foo` and `bar`. `foo` will have the password `secretpassword1` and `bar` will have the password `secretpassword2`.

## Creating additional databases (e.g., for testing)

Django likes to use a separate database for testing, by default named `test_<YOUR DATABASE NAME>`. You can create and grant privileges to work with such a database by using the `MYSQL_EXTRA_DATABASES` environment variable, which can include variables in the form of `%%DATABASE%%` or `%%USER%%`.

```console
$ docker run --name test-mysql -e MYSQL_DATABASES="foo mar" -e MYSQL_EXTRA_DATABASES="test_%%DATABASE%%" -d jamesmallen/mysql-multidb
```
... will create four databases, `foo`, `test_foo`, `bar`, and `test_bar`, and two users, `foo` and `bar`, both of which have an empty password.


## `docker compose` usage

```yaml
version: '2'
services:
  db:
    image: jamesmallen/mysql-multidb
    environment:
      MYSQL_DATABASES: foo bar
  foo:
    image: python
    # ...
  bar:
    image: python
    # ...
```

If you wish to be able to access the database from your host machine, make sure to map port `3306`:

```yaml
  db:
    # ...
    ports:
      - 3306:3306
```

## Environment Variables

All of the original `mysql` environment variables are still usable (see https://hub.docker.com/r/library/mysql/), although one variable has been changed by default. `MYSQL_ALLOW_EMPTY_PASSWORD` is set to `yes`, meaning that the default `root` account has a blank password. This is insecure by design - this image is designed to be used only in local development and automated testing environments.

### `MYSQL_DATABASES`

Set this to a space separated list of database names to create.

### `MYSQL_USERS`

Set this to a space separated list of database users to create. Each user will have access to the respective database defined in `MYSQL_DATABASES`. If this is unset and `MYSQL_DATABASES` is set, it will create a user with the same name as the database.

### `MYSQL_PASSWORDS`

Set this to a space separated list of passwords to assign to the respective user in `MYSQL_USERS`. If this is unset, it will create users with empty passwords.

### `MYSQL_EXTRA_DATABASES`

