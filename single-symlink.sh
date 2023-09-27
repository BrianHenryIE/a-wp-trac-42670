#!/bin/bash

# Set up so the plugin is symlinked in a way the entire WordPress install is within its directory.
#
# /var/www/a-wp-trac-42670.php                          # The test plugin
# /var/www/html/                                        # WordPress
# /var/www/html/wp-content/plugins                      # The plugins directory
# /var/www/html/wp-content/plugins/a-wp-trac-42670/     # Symlink to `/var/www/` (the test plugin)

ln -s /var/www /var/www/html/wp-content/plugins/a-wp-trac-42670