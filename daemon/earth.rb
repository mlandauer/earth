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
  puts "#{$0} [<directory path>]"
  puts "Monitor a local directory recursively for changes and keep up-to-date"
  puts "information in a database."
  exit 1
end

if ARGV.length > 1
  usage
end

config_file = "../config/earth.yml"
update_time = eval(YAML.load(File.open(config_file))["update_time"])
puts "Update time is set to #{update_time} seconds. To change edit #{config_file}"

this_server = Server.this_server
updater = FileDatabaseUpdater.new(this_server)

if ARGV.length == 1
  watch_directory = File.expand_path(ARGV[0])
  puts "WARNING: Watching new directory. So, clearing out database"
  this_server.directories.clear
    
  directory = updater.directory_added(nil, watch_directory)
else
  directories = Directory.roots_for_server(this_server)
  raise "Currently not properly supporting multiple watch directories" if directories.size > 1
  directory = directories[0]
  if directory.nil?
    puts "Watch directory is not set for this server. Use optional <directory path> argument."
    puts
    usage
  end
  puts "Collecting startup data from database..."
end

monitor = PosixFileMonitor.new(directory, updater)
puts "Watching directory #{directory.path}"

while true do
  puts "Updating..."
  monitor.update
  puts "Sleeping for #{update_time} seconds..."
  sleep(update_time)
end
