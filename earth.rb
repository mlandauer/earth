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

require 'monitor_with_database'

def usage
  puts "#{$0} <directory>"
  puts "Monitor a local directory recursively for changes and keep up-to-date"
  puts "information in a database."
  exit 1
end

if ARGV.length != 1
  usage
end

directory = ARGV[0]

db_updater = FileDatabaseUpdater.new
monitor = PosixFileMonitor.new(directory)
monitor.observer = db_updater

while true do
  puts "Updating..."
  monitor.update
  puts "Sleeping..."
  sleep(10)
end

