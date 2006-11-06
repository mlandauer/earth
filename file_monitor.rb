# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require 'thread'
require 'snapshot'

class FileMonitor
  attr_writer :observer

  def file_added(directory, name, stat)
    raise("No observer set") if @observer.nil?
    #puts "File ADDED: #{full_path}"
    @observer.file_added(directory, name, stat)
  end
  
  def file_removed(directory, name)
    raise("No observer set") if @observer.nil?
    #puts "File REMOVED: #{full_path}"
    @observer.file_removed(directory, name)
  end
  
  def file_changed(directory, name, stat)
    raise("No observer set") if @observer.nil?
    #puts "File CHANGED: #{full_path}"
    @observer.file_changed(directory, name, stat)
  end
end
