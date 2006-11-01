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
  attr_reader :queue
  
  def initialize(directory)
    @directory = directory
    @snapshot = Snapshot.new
  end
  
  def exist?(path)
    @snapshot.exist?(path)
  end
  
  def file_added(path, name, stat)
    puts "File #{name} at #{path} added"
  end
  
  def file_removed(path, name)
    puts "File #{name} at #{path} removed"
  end
  
  def file_changed(path, name, stat)
    puts "File #{name} at #{path} has changed"
  end
  
  def update
    new_snapshot = Snapshot.new(@directory)
    Snapshot.added_files(@snapshot, new_snapshot).each {|x| file_added(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    Snapshot.removed_files(@snapshot, new_snapshot).each {|x| file_removed(File.dirname(x), File.basename(x))}
    Snapshot.changed_files(@snapshot, new_snapshot).each {|x| file_changed(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    @snapshot = new_snapshot
  end
end

FileAdded = Struct.new(:path, :name, :stat)
FileRemoved = Struct.new(:path, :name)
FileChanged = Struct.new(:path, :name, :stat)

class MonitorWithQueue < FileMonitor
  def initialize(directory)
    super(directory)
    @queue = Queue.new    
  end
  
  def file_added(path, name, stat)
    @queue.push(FileAdded.new(path, name, stat))
  end
  
  def file_removed(path, name)
    @queue.push(FileRemoved.new(path, name))
  end
  
  def file_changed(path, name, stat)
    @queue.push(FileChanged.new(path, name, stat))
  end
end

