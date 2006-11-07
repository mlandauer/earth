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
  def initialize(observer)
    @observer = observer
  end
  
  def file_added(directory, name, stat)
    #puts "File ADDED: #{name} in directory #{directory}"
    @observer.file_added(directory, name, stat)
  end
  
  def file_removed(directory, name)
    #puts "File REMOVED: #{name} in directory #{directory}"
    @observer.file_removed(directory, name)
  end
  
  def file_changed(directory, name, stat)
    #puts "File CHANGED: #{name} in directory #{directory}"
    @observer.file_changed(directory, name, stat)
  end
  
  def directory_added(directory)
    #puts "Directory ADDED: #{directory}"
    @observer.directory_added(directory)
  end
  
  def directory_removed(directory)
    #puts "Directory REMOVED: #{directory}"
    @observer.directory_removed(directory)
  end
end
