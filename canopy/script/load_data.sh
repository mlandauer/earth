#!/bin/bash
#
# Wrapper script so that we can set the env variables
# properly as CRON just sets a basic SHELL and PATH

export PATH=$PATH:/usr/local/bin:/usr/local/pgsql/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/pgsql/lib

/usr/local/bin/ruby /var/www/rspintranet/script/load_data.rb
