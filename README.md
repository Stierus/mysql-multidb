# MySQL Multi-DB

MySQL Docker image to create multiple users/databases using environment variables

GitHub: https://github.com/jamesmallen/mysql-multidb

## Environment Variables

All of the original `mysql` environment variables are still usable (see https://hub.docker.com/r/library/mysql/), although one variable has been changed by default. `MYSQL_ALLOW_EMPTY_PASSWORD` is set to `yes`, meaning that the default `root` account has a blank password. This is insecure by design - this image is designed to be used only in local development and automated testing environments.

### `MYSQL_DATABASES`

Set this to a space separated list of database names to create.

### `MYSQL_USERS`

Set this to a space separated list of database users to create. Each user will have access to the respective database defined in `MYSQL_DATABASES`. If this is unset and `MYSQL_DATABASES` is set, it will create a user with the same name as the database.

### `MYSQL_PASSWORDS`

Set this to a space separated list of passwords to assign to the respective user in `MYSQL_USERS`. If this is unset, it will create users with empty passwords.
