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

server = Server.this_server
updater = FileDatabaseUpdater.new

if ARGV.length == 1
  watch_directory = File.expand_path(ARGV[0])
  puts "WARNING: Watching new directory. So, clearing out database"
  # TODO: Need to clear out database just for this server
  FileInfo.delete_all
  Directory.delete_all
    
  directory = updater.directory_added(nil, watch_directory)
  server.directory = directory
  server.save
else
  directory = server.directory
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
  puts "Sleeping for ten seconds..."
  sleep(10)
end
