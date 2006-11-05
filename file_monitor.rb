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

class FileMonitorBase
  attr_writer :observer

  def file_added(path, name, stat)
    raise("No observer set") if @observer.nil?
    @observer.file_added(path, name, stat)
  end
  
  def file_removed(path, name)
    raise("No observer set") if @observer.nil?
    @observer.file_removed(path, name)
  end
  
  def file_changed(path, name, stat)
    raise("No observer set") if @observer.nil?
    @observer.file_changed(path, name, stat)
  end
  
end

class FileMonitor < FileMonitorBase
  def initialize(directory)
    @directory = directory
    @snapshot = Snapshot.new
  end
  
  def update   
    new_snapshot = Snapshot.new(@directory)
    Snapshot.added_files(@snapshot, new_snapshot).each {|x| file_added(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    Snapshot.removed_files(@snapshot, new_snapshot).each {|x| file_removed(File.dirname(x), File.basename(x))}
    Snapshot.changed_files(@snapshot, new_snapshot).each {|x| file_changed(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    @snapshot = new_snapshot
  end
end
