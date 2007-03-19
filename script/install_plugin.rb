#!/usr/bin/env ruby

# Copyright (C) 2007 Rising Sun Pictures and Matthew Landauer
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#ENV["RAILS_ENV"] = "development"
#require File.dirname(__FILE__) + '/../config/environment'

require File.join(File.dirname(__FILE__), '..', 'lib', 'earth_plugin_interface', 'plugin_manager')

plugin_manager = PluginManager.new

begin
  plugin = plugin_manager.install_from_file(ARGV[0])
rescue => err
  $stderr.puts "Unable to install plug-in: #$!"
  raise
end
