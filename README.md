# Test instructions for WordPress Trac ticket 42670 

## Symlinked plugin makes plugin_basename function return wrong basename

These test steps were written for Apache on MacOS and MariaDB.

Apache is assumed to be running on port 8080. Install the repo as a subfolder to the webserver root. Other setups will require changes to `.env.testing` and `.htaccess`.

* Ticket: [core.trac.wordpress.org/ticket/42670](https://core.trac.wordpress.org/ticket/42670)
* Patch: [github.com/WordPress/wordpress-develop/pull/3412](https://github.com/WordPress/wordpress-develop/pull/3412)
* Plugins affected: [wpdirectory.net/search](https://wpdirectory.net/search/01H3G0X3ZPYCJHNGRKBTBNDMTY) (10655+)

```bash
git clone https://github.com/BrianHenryIE/a-wp-trac-42670.git;
cd a-wp-trac-42670;

composer install;

# Make .env.testing available to zsh or bash.
[[ $0 == "-zsh" ]] && source .env.testing || export $(grep -v '^#' .env.testing | xargs);

# Create the test site database and user in MariaDB or MySql.
[[ $(mysqld --version) =~ .*MariaDB.* ]] && mysql -e "CREATE USER IF NOT EXISTS '$TEST_SITE_DB_USER'@'%' IDENTIFIED BY '$TEST_SITE_DB_PASSWORD';" || mysql -e "CREATE USER IF NOT EXISTS '$TEST_SITE_DB_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$TEST_SITE_DB_PASSWORD'";
mysql -e "CREATE DATABASE IF NOT EXISTS $TEST_SITE_DB_NAME; USE $TEST_SITE_DB_NAME; GRANT ALL PRIVILEGES ON $TEST_SITE_DB_NAME.* TO '$TEST_SITE_DB_USER'@'%';";

# Create wp-config.php and install WordPress.
wp config create --dbname=$TEST_SITE_DB_NAME --dbuser=$TEST_SITE_DB_USER --dbpass=$TEST_SITE_DB_PASSWORD --allow-root --config-file=./wp-config.php;
wp core install --url=\"$TEST_SITE_WP_URL\" --title=\"$PLUGIN_NAME\" --admin_user=admin --admin_password=password --admin_email=admin@example.org;
wp config set WP_DEBUG true --raw; wp config set WP_DEBUG_LOG true --raw; wp config set WP_DEBUG_DISPLAY false --raw; wp config set SCRIPT_DEBUG true --raw;

wp plugin activate --all

open http://localhost:8080/a-wp-trac-42670/wp-admin/plugins.php
```

Observe: when plugin `a-wp-trac-42670` is active, the "settings" links for the other plugins are missing.

![42670-problem-visible.png](42670-problem-visible.png)

![42670-problem-not-visible.png](42670-problem-not-visible.png)

```bash
# Apply the patch
wget https://github.com/WordPress/wordpress-develop/pull/3412.patch
cd wordpress; patch -i ../3412.patch -p 2 -s -N -f --no-backup-if-mismatch --reject-file=; cd ..
```

Observe: the "settings" links for the other plugins are visible regardless of the status of `a-wp-trac-42670`.

![42670-problem-fixed.png](42670-problem-fixed.png)

```bash
# To reset WordPress to 6.2.2 without the patch:
rm -rf wordpress; composer install;

# Delete the database and user.
$ mysql -e "DROP DATABASE IF EXISTS $TEST_SITE_DB_NAME;";
$ mysql -e "DROP USER IF EXISTS $TEST_SITE_DB_USER;";
DB_DIR=$(mysql -e "select @@datadir" -N -B); 
$ rm -rf $DB_DIR$TEST_SITE_DB_NAME;

# Delete this test project!
$ cd ..; rm -rf a-wp-trac-42670;
```
