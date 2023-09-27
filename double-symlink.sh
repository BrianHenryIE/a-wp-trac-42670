#!/bin/bash

# Set up so the plugin is symlinked in a way the entire WordPress install is within its directory.
# And wp-content/plugins is also symlinked. I.e. the test plugin is a symlink inside a symlink.
#
# /var/www/a-wp-trac-42670.php          # The test plugin
# /var/www/html/                        # WordPress
# /var/www/html/wp-content/plugins      # Symlink to /var/www
# /var/www/wp-content/plugins                     # The plugins dir
# /var/www/wp-content/plugins/a-wp-trac-42670/    # The symlink to the test plugin

rm -rf /var/www/html/wp-content/plugins/
ln -sf /var/www/wp-content/plugins/ /var/www/html/wp-content

ln -s /var/www /var/www/wp-content/plugins/a-wp-trac-42670