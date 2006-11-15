#!/usr/bin/env ruby
#
# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require '../config/environment'

def usage
  puts "#{$0}"
  puts "Monitor a local directory recursively for changes and keep up-to-date"
  puts "information in a database. To set the directory to watch use the web"
  puts "admin front end."
  exit 1
end

if ARGV.length != 0
  usage
end

while true do
  updater = FileDatabaseUpdater.new
  current_watch_directory = Server.this_server.watch_directory
  monitor = PosixFileMonitor.new(current_watch_directory, updater)
  
  while Server.this_server.watch_directory == current_watch_directory do
    puts "Updating..."
    monitor.update
    puts "Sleeping..."
    sleep(10)
  end
  
  puts "The watch directory has changed. So, restarting daemon"
end
