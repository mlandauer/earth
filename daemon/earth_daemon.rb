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

opts = OptionParser.new
opts.banner = <<END_OF_STRING
Monitor a local directory recursively for changes and keep up-to-date
information in a database
Usage: #{$0} [-d] [<directory path>]
END_OF_STRING
opts.on("-d", "--development", "Run the daemon in development mode.") { development_mode = true }
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

if ARGV.length > 1
  puts opts
  exit 1
end

# Set environment to run in
if development_mode
  ENV["RAILS_ENV"] = "development"
else
  ENV["RAILS_ENV"] = "production"
end
require File.dirname(__FILE__) + '/../config/environment'

config_file = File.dirname(__FILE__) + "/../config/earth.yml"

if ARGV.length == 1
  FileMonitor.run_on_new_directory(ARGV[0])
else
  FileMonitor.run_on_existing_directory
end
