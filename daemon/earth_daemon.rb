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

require 'optparse'

development_mode = false
test_mode = false
only_initial_update = false
clear = false
force_update_time = nil

opts = OptionParser.new
opts.banner = <<END_OF_STRING
Monitor directories recursively for changes and keep up-to-date
information in a database
Usage: #{$0} [-d][-i] <directory path> [<directory path>..] || -c
END_OF_STRING
opts.on("-d", "--development", "Run the daemon in development mode.") { development_mode = true }
opts.on("-t", "--test", "Run the daemon in test mode.") { test_mode = true }
opts.on("-i", "--initial-only", "Only scan a new directory, do not update continuously.") { only_initial_update = true }
opts.on("-c", "--clear", "Clears *all* data for this server out of the database (Use with caution!)") { clear = true }
opts.on("-u", "--update-interval SECONDS", "Ignore update_interval stored in database and use given update interval instead") do |_force_update_time|
  force_update_time = _force_update_time.to_i
end
opts.on_tail("-h", "--help", "Show this message") do
  puts opts
  exit
end

begin
  opts.parse!(ARGV)
rescue
  puts opts
  exit 1
end

# With -c there shouldn't be a directory. Otherwise there should
if clear
  if ARGV.length != 0
    puts opts
    exit 1
  end
else
  if ARGV.length < 1
    puts opts
    exit 1
  end
end

# Set environment to run in
if development_mode and test_mode
  puts "ERROR: you can not specify --development and --test (or -d and -t) at the same time."
  exit 1
end

if development_mode
  ENV["RAILS_ENV"] = "development"
elsif test_mode
  ENV["RAILS_ENV"] = "test"
else
  ENV["RAILS_ENV"] = "production"
end
require File.dirname(__FILE__) + '/../config/environment'

if clear
  FileMonitor.database_cleanup
  exit
end

FileMonitor.start(ARGV, only_initial_update, force_update_time)
